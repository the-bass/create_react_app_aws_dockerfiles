FROM node:9.6.1

RUN apt-get -qq update

# Install python.
RUN apt-get -y install python-dev

# Install pip.
RUN curl -O https://bootstrap.pypa.io/get-pip.py
RUN python get-pip.py

# Install AWS CLI and dependecies.
RUN pip install awscli
RUN apt-get -y install groff

# Install yarn.
RUN apt-get -y install apt-transport-https

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get -qq update
RUN apt-get -y install yarn=1.6.0-1

RUN apt-get clean

# Install create-react-app.
RUN yarn global add create-react-app@1.5.2
