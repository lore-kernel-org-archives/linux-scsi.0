From: "Bean Huo (beanhuo)" <beanhuo@micron.com>
Subject: RE: [PATCH for sg3_utils 0/4] Simplify the sg3_utils configure script
Date: Wed, 3 Jan 2018 09:37:31 +0000
Message-ID: <0ecf9f85250f4269b98bd85c8c3592fa@SIWEX5A.sing.micron.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout.micron.com ([137.201.242.129]:34756 "EHLO
        mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752170AbeACJiJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Jan 2018 04:38:09 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>, Doug Gilbert <dgilbert@interlog.com>
Cc: Hannes Reinecke <hare@suse.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hi, Bart and Dong
Do you think we need to submit all changed diff including some generated files by automake?
Such as config.h.in, Makefile.in..., in fact, we only manually did a few modificaiton on
Some files such as configura.ac,makefile.am.
 
>
>Hello Doug,
>
>The four patches in this series is what I came up with after having reviewed
>the sg3_utils configure script. Please consider to apply these patches on the
>sg3_utils trunk.
>
>Thanks,
>
>Bart.
>
>Bart Van Assche (4):
>  configure.ac: Suppress an autoconf warning
>  configure.ac: Only link with the pthread library if required
>  configure.ac: Avoid code duplication
>  configure.ac, Makefile.am: Use CFLAGS and LIBS instead of os_cflags
>    and os_libs
>
> Makefile.in         |   3 +-
> config.h.in         |   6 +-
> configure           | 672 +++++++++++++++++++---------------------------------
> configure.ac        |  83 +++----
> doc/Makefile.in     |   3 +-
> include/Makefile.in |   3 +-
> lib/Makefile.am     |   2 +-
> lib/Makefile.in     |   5 +-
> scripts/Makefile.in |   3 +-
> src/Makefile.am     | 140 ++++++-----
> src/Makefile.in     | 145 ++++++------
> 11 files changed, 425 insertions(+), 640 deletions(-)
>
>--
>2.15.1
