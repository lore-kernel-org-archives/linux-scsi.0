From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] target updates for v3.20-rc1
Date: Sat, 21 Feb 2015 13:24:40 -0800
Message-ID: <CA+55aFyWD-iUxfKqYZEVZgMtqLOq6AJokAAxWo8m+iLJm-srGQ@mail.gmail.com>
References: <1424474635.1477.41.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1424474635.1477.41.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Feb 20, 2015 at 3:23 PM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
>
>  34 files changed, 1776 insertions(+), 1636 deletions(-)
>  delete mode 100644 drivers/target/iscsi/iscsi_target_core.h
>  delete mode 100644 drivers/target/iscsi/iscsi_target_stat.h
>  create mode 100644 include/target/iscsi/iscsi_target_core.h
>  create mode 100644 include/target/iscsi/iscsi_target_stat.h

Please fix your diff generation scripts. You should use "git diff -M
--stat --summary", and get something like this instead:

 32 files changed, 829 insertions(+), 689 deletions(-)
 rename {drivers => include}/target/iscsi/iscsi_target_core.h (98%)
 rename {drivers => include}/target/iscsi/iscsi_target_stat.h (100%)

rather than show that file movement as some delete/create pair.

                   Linus
