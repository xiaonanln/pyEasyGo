import os
from setuptools import setup
from setuptools import Extension

from Cython.Distutils import build_ext
pxds = ["pyEasyGo/GoHeader.pxd"]
ext_modules = [
			Extension("pyEasyGo.GoModule", ["pyEasyGo/GoModule.pyx"]+pxds),
			Extension("pyEasyGo.GoHeader", ["pyEasyGo/GoHeader.pyx"]+pxds),
		]
commands = {'build_ext': build_ext}

setup(
  name = 'pyEasyGo',
  ext_modules = ext_modules,
  packages = ['pyEasyGo'],
  package_dir = {'pyEasyGo': 'pyEasyGo'},
  cmdclass=commands,
)
