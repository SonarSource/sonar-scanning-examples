# Python

## Generate test reports

```bash
# install coverage report tool
pip3 install coverage

# install execution report tool
pip3 install unittest-xml-reporting

cd sonar-scanner

# generate coverage report
coverage run -m unittest discover -s src/python/
coverage xml -o coverage-report/coverage-python.xml

# generate execution report
python3 -m xmlrunner discover -s src/python/ -o coverage-report/execution-python.xml
```