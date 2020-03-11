Return-Path: <SRS0=VRpU=44=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 940D2C18E5A
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Mar 2020 13:06:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6345C21D7E
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Mar 2020 13:06:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729529AbgCKNGj convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Mar 2020 09:06:39 -0400
Received: from mail-vs1-f66.google.com ([209.85.217.66]:32933 "EHLO
        mail-vs1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729345AbgCKNGj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Mar 2020 09:06:39 -0400
Received: by mail-vs1-f66.google.com with SMTP id n27so1272250vsa.0;
        Wed, 11 Mar 2020 06:06:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=oaTeqhC6qgLSXZl/UFMFW2Fmg1FWD9E96HastlfJM/o=;
        b=V0lehw8G3MgX057tpXXzeVaBjco+QXY+0ZH8AwC84ftOrf2qihCZe2asnBfqfJyxNP
         OMEJ0vNvKp7BDsuK/hAc0dfBgo4MCYsVudRuWCv9k1nxI23VCOxv/G4Z2uYK0jPAE+yp
         aOCN/x4PCvTep01oM3a3OCXTdfZHU4cu+uG91k+wLtvuyj53PUOVBZlCU7yuRxPVnc6U
         QUDzzzcBgdKiL9hgZ39DqFxHIytMTEU7OMas3fc7qJz2iFbBKDwqz/GRuMMgP1wnxFBg
         tSheUxpIfDEsJFiqYf6xfnkFzqLEimbFW8V0/is/2QyLuCxONl4NVB2eGKJdDmacoB4Z
         Ghmg==
X-Gm-Message-State: ANhLgQ36J/aAPURkGDewbKepwjguwoR8i8HSIeABgukVtc2dP2MM/ag1
        jfCwciQ6m5x0ejyY3mYk7iCKT02J5Yw92jARXV8=
X-Google-Smtp-Source: ADFU+vvWAOxeEh3q5fXOdUlwbjev6h/RPoWQoIn4jFYvSrBr7JFgpO2C6xg1ZMko6lqbAhcN1p1CmI81qYmXgH6OeDY=
X-Received: by 2002:a67:1b87:: with SMTP id b129mr1940386vsb.87.1583931996768;
 Wed, 11 Mar 2020 06:06:36 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1583136624.git.mchehab+huawei@kernel.org> <6385a411d000dad005b78647629e43700580ecf0.1583136624.git.mchehab+huawei@kernel.org>
In-Reply-To: <6385a411d000dad005b78647629e43700580ecf0.1583136624.git.mchehab+huawei@kernel.org>
From:   Masanori Goto <gotom@debian.or.jp>
Date:   Wed, 11 Mar 2020 22:06:25 +0900
Message-ID: <CALZLnaHY7rtLXHNmUv77Sj6X06MGXoR_cXBmABp_CockmMJM+A@mail.gmail.com>
Subject: Re: [PATCH 24/42] docs: scsi: convert NinjaSCSI.txt to ReST
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

2020年3月2日(月) 17:17 Mauro Carvalho Chehab <mchehab+huawei@kernel.org>:
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Acked-by: GOTO Masanori <gotom@debian.or.jp>

> ---
>  .../scsi/{NinjaSCSI.txt => NinjaSCSI.rst}     | 198 +++++++++++-------
>  Documentation/scsi/index.rst                  |   1 +
>  MAINTAINERS                                   |   4 +-
>  drivers/scsi/pcmcia/Kconfig                   |   2 +-
>  4 files changed, 121 insertions(+), 84 deletions(-)
>  rename Documentation/scsi/{NinjaSCSI.txt => NinjaSCSI.rst} (28%)
>
> diff --git a/Documentation/scsi/NinjaSCSI.txt b/Documentation/scsi/NinjaSCSI.rst
> similarity index 28%
> rename from Documentation/scsi/NinjaSCSI.txt
> rename to Documentation/scsi/NinjaSCSI.rst
> index ac8db8ceec77..999a6ed5bf7e 100644
> --- a/Documentation/scsi/NinjaSCSI.txt
> +++ b/Documentation/scsi/NinjaSCSI.rst
> @@ -1,127 +1,163 @@
> +.. SPDX-License-Identifier: GPL-2.0
>
> -         WorkBiT NinjaSCSI-3/32Bi driver for Linux
> +=========================================
> +WorkBiT NinjaSCSI-3/32Bi driver for Linux
> +=========================================
>
>  1. Comment
> - This is Workbit corp.'s(http://www.workbit.co.jp/) NinjaSCSI-3
> +==========
> +
> +This is Workbit corp.'s(http://www.workbit.co.jp/) NinjaSCSI-3
>  for Linux.
>
>  2. My Linux environment
> -Linux kernel: 2.4.7 / 2.2.19
> -pcmcia-cs:    3.1.27
> -gcc:          gcc-2.95.4
> -PC card:      I-O data PCSC-F (NinjaSCSI-3)
> -              I-O data CBSC-II in 16 bit mode (NinjaSCSI-32Bi)
> -SCSI device:  I-O data CDPS-PX24 (CD-ROM drive)
> -              Media Intelligent MMO-640GT (Optical disk drive)
> +=======================
> +
> +:Linux kernel: 2.4.7 / 2.2.19
> +:pcmcia-cs:    3.1.27
> +:gcc:          gcc-2.95.4
> +:PC card:      I-O data PCSC-F (NinjaSCSI-3),
> +               I-O data CBSC-II in 16 bit mode (NinjaSCSI-32Bi)
> +:SCSI device:  I-O data CDPS-PX24 (CD-ROM drive),
> +               Media Intelligent MMO-640GT (Optical disk drive)
>
>  3. Install
> -[1] Check your PC card is true "NinjaSCSI-3" card.
> +==========
> +
> +(a) Check your PC card is true "NinjaSCSI-3" card.
> +
>      If you installed pcmcia-cs already, pcmcia reports your card as UNKNOWN
>      card, and write ["WBT", "NinjaSCSI-3", "R1.0"] or some other string to
>      your console or log file.
> +
>      You can also use "cardctl" program (this program is in pcmcia-cs source
>      code) to get more info.
>
> -# cat /var/log/messages
> -...
> -Jan  2 03:45:06 lindberg cardmgr[78]: unsupported card in socket 1
> -Jan  2 03:45:06 lindberg cardmgr[78]:   product info: "WBT", "NinjaSCSI-3", "R1.0"
> -...
> -# cardctl ident
> -Socket 0:
> -  no product info available
> -Socket 1:
> -  product info: "IO DATA", "CBSC16       ", "1"
> +    ::
>
> +       # cat /var/log/messages
> +       ...
> +       Jan  2 03:45:06 lindberg cardmgr[78]: unsupported card in socket 1
> +       Jan  2 03:45:06 lindberg cardmgr[78]:   product info: "WBT", "NinjaSCSI-3", "R1.0"
> +       ...
> +       # cardctl ident
> +       Socket 0:
> +         no product info available
> +       Socket 1:
> +         product info: "IO DATA", "CBSC16       ", "1"
>
> -[2] Get the Linux kernel source, and extract it to /usr/src.
> +
> +(b) Get the Linux kernel source, and extract it to /usr/src.
>      Because the NinjaSCSI driver requires some SCSI header files in Linux
>      kernel source, I recommend rebuilding your kernel; this eliminates
>      some versioning problems.
> -$ cd /usr/src
> -$ tar -zxvf linux-x.x.x.tar.gz
> -$ cd linux
> -$ make config
> -...
>
> -[3] If you use this driver with Kernel 2.2, unpack pcmcia-cs in some directory
> +    ::
> +
> +       $ cd /usr/src
> +       $ tar -zxvf linux-x.x.x.tar.gz
> +       $ cd linux
> +       $ make config
> +       ...
> +
> +(c) If you use this driver with Kernel 2.2, unpack pcmcia-cs in some directory
>      and make & install. This driver requires the pcmcia-cs header file.
> -$ cd /usr/src
> -$ tar zxvf cs-pcmcia-cs-3.x.x.tar.gz
> -...
>
> -[4] Extract this driver's archive somewhere, and edit Makefile, then do make.
> -$ tar -zxvf nsp_cs-x.x.tar.gz
> -$ cd nsp_cs-x.x
> -$ emacs Makefile
> -...
> -$ make
> +    ::
>
> -[5] Copy nsp_cs.ko to suitable place, like /lib/modules/<Kernel version>/pcmcia/ .
> +       $ cd /usr/src
> +       $ tar zxvf cs-pcmcia-cs-3.x.x.tar.gz
> +       ...
> +
> +(d) Extract this driver's archive somewhere, and edit Makefile, then do make::
> +
> +       $ tar -zxvf nsp_cs-x.x.tar.gz
> +       $ cd nsp_cs-x.x
> +       $ emacs Makefile
> +       ...
> +       $ make
> +
> +(e) Copy nsp_cs.ko to suitable place, like /lib/modules/<Kernel version>/pcmcia/ .
> +
> +(f) Add these lines to /etc/pcmcia/config .
>
> -[6] Add these lines to /etc/pcmcia/config .
>      If you use pcmcia-cs-3.1.8 or later, we can use "nsp_cs.conf" file.
>      So, you don't need to edit file. Just copy to /etc/pcmcia/ .
>
> --------------------------------------
> -device "nsp_cs"
> -  class "scsi" module "nsp_cs"
> -
> -card "WorkBit NinjaSCSI-3"
> -  version "WBT", "NinjaSCSI-3", "R1.0"
> -  bind "nsp_cs"
> -
> -card "WorkBit NinjaSCSI-32Bi (16bit)"
> -  version "WORKBIT", "UltraNinja-16", "1"
> -  bind "nsp_cs"
> -
> -# OEM
> -card "WorkBit NinjaSCSI-32Bi (16bit) / IO-DATA"
> -  version "IO DATA", "CBSC16       ", "1"
> -  bind "nsp_cs"
> -
> -# OEM
> -card "WorkBit NinjaSCSI-32Bi (16bit) / KME-1"
> -  version "KME    ", "SCSI-CARD-001", "1"
> -  bind "nsp_cs"
> -card "WorkBit NinjaSCSI-32Bi (16bit) / KME-2"
> -  version "KME    ", "SCSI-CARD-002", "1"
> -  bind "nsp_cs"
> -card "WorkBit NinjaSCSI-32Bi (16bit) / KME-3"
> -  version "KME    ", "SCSI-CARD-003", "1"
> -  bind "nsp_cs"
> -card "WorkBit NinjaSCSI-32Bi (16bit) / KME-4"
> -  version "KME    ", "SCSI-CARD-004", "1"
> -  bind "nsp_cs"
> --------------------------------------
> -
> -[7] Start (or restart) pcmcia-cs.
> -# /etc/rc.d/rc.pcmcia start        (BSD style)
> -or
> -# /etc/init.d/pcmcia start         (SYSV style)
> +    ::
> +
> +       device "nsp_cs"
> +         class "scsi" module "nsp_cs"
> +
> +       card "WorkBit NinjaSCSI-3"
> +         version "WBT", "NinjaSCSI-3", "R1.0"
> +         bind "nsp_cs"
> +
> +       card "WorkBit NinjaSCSI-32Bi (16bit)"
> +         version "WORKBIT", "UltraNinja-16", "1"
> +         bind "nsp_cs"
> +
> +       # OEM
> +       card "WorkBit NinjaSCSI-32Bi (16bit) / IO-DATA"
> +         version "IO DATA", "CBSC16       ", "1"
> +         bind "nsp_cs"
> +
> +       # OEM
> +       card "WorkBit NinjaSCSI-32Bi (16bit) / KME-1"
> +         version "KME    ", "SCSI-CARD-001", "1"
> +         bind "nsp_cs"
> +       card "WorkBit NinjaSCSI-32Bi (16bit) / KME-2"
> +         version "KME    ", "SCSI-CARD-002", "1"
> +         bind "nsp_cs"
> +       card "WorkBit NinjaSCSI-32Bi (16bit) / KME-3"
> +         version "KME    ", "SCSI-CARD-003", "1"
> +         bind "nsp_cs"
> +       card "WorkBit NinjaSCSI-32Bi (16bit) / KME-4"
> +         version "KME    ", "SCSI-CARD-004", "1"
> +         bind "nsp_cs"
> +
> +(f) Start (or restart) pcmcia-cs::
> +
> +       # /etc/rc.d/rc.pcmcia start        (BSD style)
> +
> +    or::
> +
> +       # /etc/init.d/pcmcia start         (SYSV style)
>
>
>  4. History
> +==========
> +
>  See README.nin_cs .
>
>  5. Caution
> - If you eject card when doing some operation for your SCSI device or suspend
> +==========
> +
> +If you eject card when doing some operation for your SCSI device or suspend
>  your computer, you encount some *BAD* error like disk crash.
> - It works good when I using this driver right way. But I'm not guarantee
> +
> +It works good when I using this driver right way. But I'm not guarantee
>  your data. Please backup your data when you use this driver.
>
>  6. Known Bugs
> - In 2.4 kernel, you can't use 640MB Optical disk. This error comes from
> +=============
> +
> +In 2.4 kernel, you can't use 640MB Optical disk. This error comes from
>  high level SCSI driver.
>
>  7. Testing
> - Please send me some reports(bug reports etc..) of this software.
> +==========
> +
> +Please send me some reports(bug reports etc..) of this software.
>  When you send report, please tell me these or more.
> -       card name
> -       kernel version
> -       your SCSI device name(hard drive, CD-ROM, etc...)
> +
> +       - card name
> +       - kernel version
> +       - your SCSI device name(hard drive, CD-ROM, etc...)
>
>  8. Copyright
> +============
> +
>   See GPL.
>
>
> diff --git a/Documentation/scsi/index.rst b/Documentation/scsi/index.rst
> index a2545efbb407..eb2df0e0dcb7 100644
> --- a/Documentation/scsi/index.rst
> +++ b/Documentation/scsi/index.rst
> @@ -28,5 +28,6 @@ Linux SCSI Subsystem
>     lpfc
>     megaraid
>     ncr53c8xx
> +   NinjaSCSI
>
>     scsi_transport_srp/figures
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 6d28bfc72259..2f441cf59b4b 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -11861,7 +11861,7 @@ NINJA SCSI-3 / NINJA SCSI-32Bi (16bit/CardBus) PCMCIA SCSI HOST ADAPTER DRIVER
>  M:     YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>
>  W:     http://www.netlab.is.tsukuba.ac.jp/~yokota/izumi/ninja/
>  S:     Maintained
> -F:     Documentation/scsi/NinjaSCSI.txt
> +F:     Documentation/scsi/NinjaSCSI.rst
>  F:     drivers/scsi/pcmcia/nsp_*
>
>  NINJA SCSI-32Bi/UDE PCI/CARDBUS SCSI HOST ADAPTER DRIVER
> @@ -11869,7 +11869,7 @@ M:      GOTO Masanori <gotom@debian.or.jp>
>  M:     YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>
>  W:     http://www.netlab.is.tsukuba.ac.jp/~yokota/izumi/ninja/
>  S:     Maintained
> -F:     Documentation/scsi/NinjaSCSI.txt
> +F:     Documentation/scsi/NinjaSCSI.rst
>  F:     drivers/scsi/nsp32*
>
>  NIOS2 ARCHITECTURE
> diff --git a/drivers/scsi/pcmcia/Kconfig b/drivers/scsi/pcmcia/Kconfig
> index dc9b74c9348a..9696b6b5591f 100644
> --- a/drivers/scsi/pcmcia/Kconfig
> +++ b/drivers/scsi/pcmcia/Kconfig
> @@ -36,7 +36,7 @@ config PCMCIA_NINJA_SCSI
>         help
>           If you intend to attach this type of PCMCIA SCSI host adapter to
>           your computer, say Y here and read
> -         <file:Documentation/scsi/NinjaSCSI.txt>.
> +         <file:Documentation/scsi/NinjaSCSI.rst>.
>
>           Supported cards:
>
> --
> 2.21.1
>
