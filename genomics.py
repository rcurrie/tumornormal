import numpy as np
from tensorflow.contrib.learn.python.learn.datasets import base
from keras.utils.io_utils import HDF5Matrix


class DataSet(object):
  """MNIST style class for Genomics research

  Assumes a genomics dataset is an h5 file consisting of

    X: examples as a numpy floating point array
    y: one hot array to predict
    classes: integer array of classes for stratification
    features: string array of the features in X
    labels: array of strings coresponding to the one-hot labels

  according rcurrie's specification.
  """

  def __init__(self,
               datapath,
               datasets,
               start=0,
               end=None):
    
    self._data_sets = { 
      dataset:HDF5Matrix(datapath, dataset, start=start, end=end) for dataset in datasets 
    }
    self._epochs_completed = 0
    self._index_in_epoch = 0
    self._start = start

    if end is not None:
      self._end = end
    else:
      self._end = self.num_features

    # set in the `next_batch` function.
    # A hack to shuffle the `features` data set between epochs
    # when loading directly from disc.
    self._index_array = None 

  @property
  def labels(self):
    return self._data_sets['y']

  @property
  def features(self):
    return self._data_sets['X']

  @property
  def num_features(self):
    return self._data_sets['X'].shape[0]

  @property
  def epochs_completed(self):
    return self._epochs_completed

  def next_batch(self, batch_size):
    start = self._index_in_epoch

    # We use an indirect indexing array to simulate
    # data shuffling between epochs
    if self._epochs_completed == 0 and start == 0:
      self._index_array = np.sort(np.random.permutation(np.arange(self._start, self._end)))

    # Go to the next epochs
    if start + batch_size > self.num_features:
      # Finished epoch
      self._epochs_completed += 1

      # Get the rest of the features in this epoch
      rest_num_features = self.num_features - start
      features_rest_part = self.features[self._index_array[start:self.num_features]]
      labels_rest_part = self.labels[self._index_array[start:self.num_features]]

      # Shuffle the data
      self._index_array = np.sort(np.random.permuation(np.arange(self.start, self.end)))

      # Start the next epoch
      start = 0
      self._index_in_epoch = batch_size - rest_num_features
      end = self._index_in_epoch
      features_new_part = self.features[self._index_array[start:end]]
      labels_new_part = self.labels[self._index_array[start:end]]
      return np.concatenate((features_rest_part, features_new_part), axis=0), \
             np.concatenate((labels_rest_part, labels_new_part), axis=0)

    else:
      self._index_in_epoch += batch_size
      end = self._index_in_epoch
      return self.features[self._index_array[start:end]], \
             self.labels[self._index_array[start:end]]


def read_data_sets(datapath, 
                   datasets=['X', 'y', 'classes', 'features', 'labels'],
                   validation_size=0.2, 
                   test_size=0.2):
  # TODO: Perform the data set cuts at random locations...
  
  all_features = HDF5Matrix(datapath, 'X')
  num_validation = int(validation_size * all_features.shape[0])
  num_test = int(test_size * all_features.shape[0])
  num_train = all_features.shape[0] - (num_validation + num_test)
  del all_features

  # Create the validation/test/train datasets
  start, end = 0, num_validation
  validation = DataSet(datapath, datasets, start=start, end=end)
  start, end = end, end + num_test
  test = DataSet(datapath, datasets, start=start, end=end)
  start, end = end, end + num_train
  train = DataSet(datapath, datasets, start=start, end=end)

  return base.Datasets(train=train, validation=validation, test=test)

