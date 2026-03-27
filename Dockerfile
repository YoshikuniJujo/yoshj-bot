FROM gentoo/stage3:latest

RUN emerge --sync
RUN emerge -v curl
RUN emerge -v dev-vcs/git
RUN curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
RUN . /root/.ghcup/env
ENV PATH=/root/.ghcup/bin:$PATH

# RUN ghcup install ghc 9.12.3
RUN ghcup install ghc 9.14.1
RUN ghcup install cabal 3.16.1.0
RUN ghcup install stack 3.9.3

RUN mkdir /opt/yoshj-bot-run

COPY yoshj-bot-keys /opt/yoshj-bot-keys
WORKDIR "/opt/yoshj-bot-keys"
RUN stack install
ENV PATH=/root/.local/bin:$PATH

WORKDIR "/opt/yoshj-bot-run"
RUN yoshj-bot-keys-exe

COPY yoshj-bot /opt/yoshj-bot
WORKDIR "/opt/yoshj-bot"
RUN stack install

WORKDIR "/opt/yoshj-bot-run"

CMD ["reply", "secure", "relay.nostr.wirednet.jp", "443", "nsec", "npub"]
