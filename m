From: Matt Domsch <Matt_Domsch@Dell.com>
Subject: Re: megaraid v2.00rc5
Date: Mon, 23 Sep 2002 10:19:23 -0500 (CDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0209231008450.28253-100000@humbolt.us.dell.com>
References: <Pine.LNX.4.44.0209230937050.27515-100000@humbolt.us.dell.com>
Reply-To: Matt Domsch <Matt_Domsch@Dell.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.us.dell.com (smtp2.us.dell.com [143.166.85.133])
	by zeus.kernel.org (8.11.6/8.11.6) with ESMTP id g8NGJoA19676
	for <linux-scsi@vger.kernel.org>; Mon, 23 Sep 2002 09:19:50 -0700
Received: from tux.us.dell.com (tux.us.dell.com [143.166.152.29])
	by smtp2.us.dell.com (8.12.1/8.12.5) with ESMTP id g8NFI2re021526
	for <linux-scsi@vger.kernel.org>; Mon, 23 Sep 2002 10:18:02 -0500
Received: from humbolt.us.dell.com ([10.180.92.254])
	by tux.us.dell.com (8.11.0/8.11.0) with ESMTP id g8NFJNj10221
	for <linux-scsi@vger.kernel.org>; Mon, 23 Sep 2002 10:19:23 -0500
In-Reply-To: <Pine.LNX.4.44.0209230937050.27515-100000@humbolt.us.dell.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

> Posted at http://domsch.com/linux/megaraid/megaraid-v2.00rc5.tar.gz is
> a new Release Candidate version of the megaraid driver.

Against 2.4.20-pre7 kernel, the driver can be found:

Patch:
 megaraid.c | 8538 +++++++++++++++++++++++++++++++------------------------------
 megaraid.h | 1730 ++++++------
 2 files changed, 5383 insertions, 4885 deletions

 http://domsch.com/linux/megaraid/linux-2.4.20-pre7-megaraid-2.00rc5.patch
 http://domsch.com/linux/megaraid/linux-2.4.20-pre7-megaraid-2.00rc5.patch.sign

Tarball:
 http://domsch.com/linux/megaraid/megaraid-v2.00rc5-stock-2.4.x.tar.gz
 http://domsch.com/linux/megaraid/megaraid-v2.00rc5-stock-2.4.x.tar.gz.sign

BK:
 http://mdomsch.bkbits.net/linux-2.4-megaraid


Thanks,
Matt

-- 
Matt Domsch
Sr. Software Engineer, Lead Engineer, Architect
Dell Linux Solutions www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com

