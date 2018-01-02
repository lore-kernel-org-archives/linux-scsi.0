From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH for sg3_utils 0/4] Simplify the sg3_utils configure script
Date: Tue,  2 Jan 2018 10:13:37 -0800
Message-ID: <20180102181341.13435-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:36146 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751211AbeABSNo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Jan 2018 13:13:44 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Doug Gilbert <dgilbert@interlog.com>
Cc: Hannes Reinecke <hare@suse.com>, Bean Huo <beanhuo@micron.com>, linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>

Hello Doug,

The four patches in this series is what I came up with after having reviewed
the sg3_utils configure script. Please consider to apply these patches on the
sg3_utils trunk.

Thanks,

Bart.

Bart Van Assche (4):
  configure.ac: Suppress an autoconf warning
  configure.ac: Only link with the pthread library if required
  configure.ac: Avoid code duplication
  configure.ac, Makefile.am: Use CFLAGS and LIBS instead of os_cflags
    and os_libs

 Makefile.in         |   3 +-
 config.h.in         |   6 +-
 configure           | 672 +++++++++++++++++++---------------------------------
 configure.ac        |  83 +++----
 doc/Makefile.in     |   3 +-
 include/Makefile.in |   3 +-
 lib/Makefile.am     |   2 +-
 lib/Makefile.in     |   5 +-
 scripts/Makefile.in |   3 +-
 src/Makefile.am     | 140 ++++++-----
 src/Makefile.in     | 145 ++++++------
 11 files changed, 425 insertions(+), 640 deletions(-)

-- 
2.15.1
