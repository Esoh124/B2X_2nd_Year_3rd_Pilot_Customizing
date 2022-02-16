# -*- coding: utf-8 -*-
# ---
# jupyter:
#   jupytext:
#     formats: ipynb,py:light
#     text_representation:
#       extension: .py
#       format_name: light
#       format_version: '1.5'
#       jupytext_version: 1.13.6
#   kernelspec:
#     display_name: Python 3 (ipykernel)
#     language: python
#     name: python3
# ---

# # pilot test3
# ## - main protocol test
# ## - 32ch
# ## - ch1: empty, ch33: empty --> 둘다 삭제
# ## - txt2mat
#
# ### 20220126 작성 시작

import os 
import numpy as np
import natsort
import pandas as pd
from tqdm.notebook import tqdm, trange
import scipy.io as spio
# %matplotlib inline

default_path = 'E:\\B2X\\2차년도\\3차 pilot\\subject_data'
default_path


# ## subject list 확보

def OnlyFolder(path):
    # return only folder, not file
    # path: default_path which contains subject folders
    
    dir_list = os.listdir(path) # get all directory below the path
    output = []
    for i in range(len(dir_list)):
        temp_path = os.path.join(path, dir_list[i])
        if os.path.isdir(temp_path) == True:
            output.append(dir_list[i])
    return output


total_subject_list = OnlyFolder(default_path)
total_subject_list = natsort.natsorted(total_subject_list) # 번호 순서대로 정렬
total_subject_list

# ## 분석할 subject 선택

# +
# XX_HKD 의 XX를 그대로 입력 
# ex) 05_HKD --> 5
choose_sub = range(10,21)
sub_list = []
for sub_num in range(len(choose_sub)):
   sub_list.append(total_subject_list[choose_sub[sub_num]-1])
    
print('Target Subjects: {}'.format(sub_list))


# +
def SelectTxtFiles(file_list):
    # file_list 중, 'txt' 문자열을 포함한 것만 남김
    # file_list : 검사하고자 하는 file 이름이 담긴 list
    print("\nTest... if txt or not")
    result = []
    for i in range(len(file_list)):
        test = file_list[i][-3:]
        if test == 'txt':
            result.append(file_list[i])
    print('Filtered txt files: {}'.format(result))
    return result


def TxtRead(path, filename):
    # txt 파일을 line별로 읽어서 list로 반환
    # path: 파일이 저장된 경로
    # filname : 파일 이름

    file_path = path + '\\' + filename
    
    result = []
    num = 0
    with open(file_path, 'r') as f:
        lines = f.readlines()
        for line in lines:
            data = line.strip().split()
            result.append(data)
    return result
            


# -

for sub_num in tqdm(range(len(choose_sub)), desc='Total Processing'):
    
    print('------------------------------------')
    print(sub_list[sub_num])
    # 현재 sub_num에 해당하는 subject의 txt 파일이 존재하는 경로
    subject_txt_path = default_path + '\\' + sub_list[sub_num] + '\\EEG'
    
    # txt 경로에서, 확장자명이 txt인 파일들만 선택
    txt_list = SelectTxtFiles(os.listdir(subject_txt_path))
    print('\nData Extraction Start ...')
    
    # 5개의 txt 파일에 대해서 각각 data를 추출하고, mat파일로 저장
    for stim_num in tqdm(range(len(txt_list)), desc=sub_list[sub_num] + ' Processing'):
        print('{}th txt'.format(stim_num + 1), end='.. ')
        
        temp_data = TxtRead(subject_txt_path, txt_list[stim_num])
        header = temp_data[:3] # header 성분
        non_header = temp_data[3:] # non-header --> EEG data
    
        # non_header의 마지막 row에는 빈 배열이 존재하기 때문에, numpy로 전환하면서 오류가 발생함
        # --> 마지막 row를 삭제
        if len(non_header[len(non_header)-1]) == 0:
            del non_header[len(non_header)-1] # list의 요소 제거 방법인 del을 사용
            # non_header list를 numpy array로 변환
            non_header = np.array(non_header, dtype=float)
        non_header_df = pd.DataFrame(non_header)
        
        # ch34 유무에 따른 if 문
        if non_header_df.shape[1] == 34:
            # ch34기 존재하면 이는 flag를 저장하기 위한 채널이므로 삭제하여 준다.
            # ch1은 빈배열이므로 index 0을 이용하여 제거
            # ch34는index 33을 이용하여 제거
            non_header_df = non_header_df.drop([0, 33], axis=1)
        else:
            # ch34가 존재하지 않으면, 빈 채널인 ch1만 index 0을 이용하여 제거            
            non_header_df = non_header_df.drop(0, axis=1)
            
        print(" Shape: {}, Size: {}".format(non_header_df.shape, non_header_df.size), end=' --> Save...')
        
        data = np.array(non_header_df)
        save_as = os.path.join(subject_txt_path, txt_list[stim_num][:-3]+'mat')
        spio.savemat(save_as, mdict={'data': data})
        print("done !")


k = []

len(k)

k = np.arange(0,6)
print(type(k))

t = range(0,5)

t[0]

t[1]

t[4]

t[5]


