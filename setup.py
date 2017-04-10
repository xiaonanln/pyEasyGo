import os
from setuptools import setup
from setuptools import Extension

from Cython.Distutils import build_ext

libname = 'pyEasyGo'

pxds = [libname+'/'+f for f in os.listdir(libname) if f.endswith('.pxd')]
ext_modules = [
	Extension(libname+'.'+f[:-4], [libname+'/'+f]+pxds)
	for f in os.listdir(libname) if f.endswith('.pyx')
]
commands = {'build_ext': build_ext}

setup(
  name = libname,
  version = '0.1.0', 
  author = 'xiaonanln',
  author_email='xiaonanln@gmail.com', 
  ext_modules = ext_modules,
  packages = [libname],
  package_dir = {libname: libname},
  cmdclass=commands,
)
