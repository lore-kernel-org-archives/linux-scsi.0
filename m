From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] scsi_debug on 2.5.44+scsi-misc
Date: Thu, 31 Oct 2002 12:33:53 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DC08881.8090308@torque.net>
References: <3DBF4A0E.4000200@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010007040200060800000107"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from torque.net (dm1-22.triode.net.au [202.147.125.22])
	by iggy.triode.net.au (8.11.6/8.11.6) with ESMTP id g9V1Z6C29266
	for <linux-scsi@vger.kernel.org>; Thu, 31 Oct 2002 12:35:06 +1100
List-Id: linux-scsi@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------010007040200060800000107
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Douglas Gilbert wrote:
> Here is a patch for scsi_debug against 2.5.44 plus James's
> scsi-misc BK tree. Changes:
>   - add SYNCHRONIZE_CACHE command support
>   - clean up module removal noise
>   - add some more parameters for driverfs


The attached gzipped diff file is against 2.5.44-bk3
(which is the same for scsi_debug.c as yesterday's
2.5.44+scsi-misc) and merges work from Patrick
Mansfield. There are now options to set:
   - max_luns (default 2)
   - scsi_level (default 3)

Now if multiple scsi_debug pseudo devices are selected
they will get these tuples (assuming "2" is the next
available host number):
   2 0 0 0
   2 0 0 1
   2 0 1 0
   2 0 1 1
   2 0 2 0
   ...
   2 0 7 1
   3 0 0 0
   3 0 0 1
etc

Doug Gilbert



--------------010007040200060800000107
Content-Type: application/x-gzip;
 name="scsi_debug_163_2544bk3.diff.gz"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="scsi_debug_163_2544bk3.diff.gz"

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
--------------010007040200060800000107--

