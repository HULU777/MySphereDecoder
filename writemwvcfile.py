#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Jul 18 17:22:46 2022

@author: hliucp
"""

import os
import numpy as np

def getmwvc(path,v_num,e_num):
    # randomweight = 1;
    # path = 'B5M2/B5M2.mtx'
    
    # [_,tail] = os.path.split(path)
    
    ## add 'v' and 'p'
    file = open(path, encoding = 'utf-8')
    lines = file.readlines()
    file.close()
    
    # fileroot = os.getcwd() # '/home/hliucp/Desktop/VertexCover/MySphereDecoder'
    fileroot = '/home/hliucp/Desktop/VertexCover/MySphereDecoder/VCforSD'
    pathpart = path.split('.')
    # filename = pathpart[0] + '%d'%run + '.mwvc'
    filename = pathpart[0] +'.mwvc'
    filelocation = fileroot + '/' + filename
    fp = open(filelocation,'w')
    
    # with open(filelocation,'w') as f:
    #     for ll in lines:
    #         f.write(ll)
    # fp.close()
    
    for k, v in enumerate(lines):
        if k < v_num:
            fp.write('v %s'%v)
        elif k >= v_num :
            fp.write('e %s'%v)
    fp.close()
    
    
    new_line = 'p edge %d %d \n'%(v_num, e_num)

    with open(filelocation, 'r+') as file1:
       content = file1.read()
       file1.seek(0)
       file1.write(new_line + content)
       
    #file.flush()
    
    return

if __name__=='__main__':
    randomweight = 0; #  O: each weight = 1
    B = 9
    M = 4
    L = 1
    # path = "bm2022_B%dM%d.dat"%(B,M)
    path = "CWC_B%dM%dL%d_debugC++.dat"%(B,M,L) #"CWC_B%dM%d.dat"%(B,M)   # "
    # path = 'nodepairs.dat'  
    v = 126
    p = 5040
    # path = 'bio-diseasome/bio-diseasome.mtx
    getmwvc(path,v,p)