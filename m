From: Luben Tuikov <luben@splentec.com>
Subject: scsi_scan.c
Date: Thu, 25 Jul 2002 16:42:02 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D40629A.5EE2D7B2@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from splentec.com (canoe.splentec.com [209.47.35.250])
	by pepsi.splentec.com (8.11.6/8.11.0) with ESMTP id g6PKg0s12926
	for <linux-scsi@vger.kernel.org>; Thu, 25 Jul 2002 16:42:00 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

What is the status of scsi_scan.c in 2.4.latest
and in 2.5.latest (28)?

I thought that Patric Mansfield's version would be
used? It looks to me (2.5.28) that some mixture
of old and new (P.M.) code is used. (Judging by
the the use of the old ``if (SDpnt != oldSDpnt) ...''
along with the new scsi_scan_target() by P.M.)

Currently select_queue_depths() gets quite confused
setting the queue depths unless extended effort
is used on SDpnt to see that it is the ``next''
device to be later scanned... (going through the devices)

???
-- 
Luben
