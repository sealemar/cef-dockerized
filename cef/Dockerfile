FROM debian:latest

# arch="arm64", arch="" (no-arm)
ARG arch=arm64
ENV arch="${arch:-arm64}"

# NOTE: skipped
# from https://bitbucket.org/chromiumembedded/cef/wiki/MasterBuildQuickStart.md#markdown-header-linux-setup
# 3. Install the "libgtkglext1-dev" package required by the cefclient sample application only on non-arm platforms.
# I will install it here to make the Dockerfile generic
#
# Note: some apt-get packages below come from the list of dependencies of 'install-build-deps.sh'
RUN echo "~~~~~ Building for arch=${arch}" && \
    apt-get update && apt-get install -y \
        bison \
        curl \
        flex \
        g++-8-arm-linux-gnueabihf \
        g++-aarch64-linux-gnu \
        gcc-aarch64-linux-gnu \
        gcc-arm-linux-gnueabihf \
        git \
        gperf \
        libgtkglext1-dev \
        lsb-release \
        p7zip-full \
        python \
        python-pip \
        sudo \
        time \
        zip \
    && \
    apt-get purge -y --auto-remove \
    && \
    pip install jinja2

COPY script/ /app/docker

# USER root ; and SHELL /bin/bash ; were required otherwise the following
# RUN instruction would fail at the first chmod with 'missing operand'
# see https://serverfault.com/a/960335/320690
USER root
SHELL ["/bin/bash", "-c"]

RUN chmod +x /app/docker/*.sh && \
    . /app/docker/set_env.sh \
    && \
    echo "After set_env.sh" && \
    env \
    && \
    mkdir -p /app/automate /app/chromium_git \
    && \
    cd /app && \
    curl 'https://chromium.googlesource.com/chromium/src/+/master/build/install-build-deps.sh?format=TEXT' | base64 -d > install-build-deps.sh && \
    chmod 755 install-build-deps.sh && \
    ./install-build-deps.sh ${install_build_deps_sh_arch} --no-chromeos-fonts --no-prompt ${no_nacl} \
    && \
    cd /app && \
    git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git \
    && \
    cd /app/automate && \
    curl https://bitbucket.org/chromiumembedded/cef/raw/master/tools/automate/automate-git.py --output automate-git.py \
    && \
    cd /app/chromium_git && \
    python /app/automate/automate-git.py --download-dir=/app/chromium_git --depot-tools-dir=/app/depot_tools --no-distrib --no-build ${extra_automate_args} \
    && \
    /app/docker/install_sysroot_wrapper.sh \
    && \
    cd /app/chromium_git/chromium/src/cef && \
    ./cef_create_projects.sh \
    && \
    cd /app/chromium_git/chromium/src && \
    ninja ${ninja_debug_args} cefsimple chrome_sandbox && \
    ninja ${ninja_release_args} cefsimple chrome_sandbox

WORKDIR /app

CMD /bin/bash /app/docker/cmd.sh
