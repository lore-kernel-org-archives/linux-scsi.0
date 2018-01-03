From: "Bean Huo (beanhuo)" <beanhuo@micron.com>
Subject: RE: [PATCH for sg3_utils 1/4] configure.ac: Suppress an autoconf
 warning
Date: Wed, 3 Jan 2018 09:14:18 +0000
Message-ID: <14e5b239cd7247cf8427ac990143d48d@SIWEX5A.sing.micron.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout.micron.com ([137.201.242.129]:51601 "EHLO
        mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751245AbeACJPA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Jan 2018 04:15:00 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>, Doug Gilbert <dgilbert@interlog.com>
Cc: Hannes Reinecke <hare@suse.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

>a/configure.ac b/configure.ac index 1cce0b25f583..129c2f9d4d4d 100644
>--- a/configure.ac
>+++ b/configure.ac
>@@ -7,13 +7,13 @@ AM_CONFIG_HEADER(config.h)  AC_PROG_CC  #
>AC_PROG_CXX  AC_PROG_INSTALL
>-
>-# Adding libtools to the build seems to bring in C++ environment -
>AC_PROG_LIBTOOL
>
> # AM_PROG_AR is supported and needed since automake v1.12+
>ifdef([AM_PROG_AR], [AM_PROG_AR], [])
>
>+# Adding libtools to the build seems to bring in C++ environment
>+AC_PROG_LIBTOOL
>+
> # check for headers
> AC_HEADER_STDC
>

After moving "AC_PROG_LIBTOOL" to back " ifdef([AM_PROG_AR], [AM_PROG_AR], [])",
"Warning: LT_INIT was called before AM_PROG_AR" disappears.

Tested-by: Bean Huo <beanhuo@micron.com>

>--
>2.15.1
