From: steve@purestorage.com
Subject: [PATCH 0/2] Fix the qla2xxx loopback selftests
Date: Tue, 14 Aug 2012 16:48:53 +0100
Message-ID: <502a736f.21d4320a.4e09.44cf@mx.google.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys010aog113.obsmtp.com ([74.125.245.94]:36640 "HELO
	na3sys010aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752989Ab2HNPy0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Aug 2012 11:54:26 -0400
Received: by weyz53 with SMTP id z53so466001wey.32
        for <linux-scsi@vger.kernel.org>; Tue, 14 Aug 2012 08:54:23 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-driver@qlogic.com, Andrew Vasquez <andrew.vasquez@qlogic.com>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Steve Hodgson <steve@purestorage.com>

From: Steve Hodgson <steve@purestorage.com>

A few months ago our 2.6.39 based kernel started crashing almost 100%
of the time when running the selftests, after seeminly unrelated kernel
changes. In the end it was traced down to this use after free.

Whilst here fix an error path memory leak.

Thanks,

Steve

Steve Hodgson (2):
  qla2xxx: Fix use after free in qla2x000_process_loopback.
  qla2xxx: Free rsp_data even on error in qla2x00_process_loopback()

 drivers/scsi/qla2xxx/qla_bsg.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

-- 
1.7.9.5

