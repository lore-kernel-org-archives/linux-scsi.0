From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH] scsi_debug version 1.69 for lk 2.5.66
Date: Sat, 29 Mar 2003 23:20:07 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E859D87.6020701@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040306010700010808070701"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from torque.net (d-241-31.stlucia.uq.net.au [203.101.241.31])
	by bunyip.cc.uq.edu.au (8.12.8/8.12.8) with ESMTP id h2TDJ154007678
	for <linux-scsi@vger.kernel.org>; Sat, 29 Mar 2003 23:19:07 +1000 (GMT+1000)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------040306010700010808070701
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

As people are using scsi_debug to simulate a large
number of disks to play with the dev_t expansion,
some problems have come to light.

Changelog:
   - change num_devs to num_tgts
       so now the user can independently modify the
       number of hosts (add_host), the number of targets
       per host (num_tgts) and the number of luns per
       target (max_luns)
   - num_tgts sets scsi_host::max_id after allowance is
     made for the initiator's target id
   - max_luns default changed to 1 and it is sysfs
     writeable
   - REPORT LUN response cleaned up. Could now possibly
     generate a response indicatimg there were up to
     16,384 logical units available
   - clean up sense buffer generation

Updated http://www.torque.net/sg/sdebug25.html


Doug Gilbert

--------------040306010700010808070701
Content-Type: application/x-gzip;
 name="sdebug_2566_169_5.diff.gz"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="sdebug_2566_169_5.diff.gz"

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
8hED4kQt/xtiHWJWHTUAAA==
--------------040306010700010808070701--

