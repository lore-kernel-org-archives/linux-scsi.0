From: "John Stoffel" <john@stoffel.org>
Subject: Re: Linux kernels 4.3+ mess up MPT2SAS configs
Date: Thu, 3 Dec 2015 12:54:58 -0500
Message-ID: <22112.33266.955528.209926@quad.stoffel.home>
References: <22112.13937.759625.629277@quad.stoffel.home>
	<yq1lh9ba9a1.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailrelay.lanline.com ([216.187.10.16]:32628 "EHLO
	mailrelay.lanline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867AbbLCRzE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Dec 2015 12:55:04 -0500
In-Reply-To: <yq1lh9ba9a1.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: John Stoffel <john@stoffel.org>, MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, nagalakshmi.nandigama@avagotech.com, praveen.krishnamoorthy@avagotech.com, sreekanth.reddy@avagotech.com

>>>>> "Martin" == Martin K Petersen <martin.petersen@oracle.com> writes:

>>>>> "John" == John Stoffel <john@stoffel.org> writes:
John> I've got an LSI MPT2SAS controller in my home system, great board,
John> running well.  When I try to use kernels newer than approximately
John> 4.3.0, the default Kconfig entry goes away because of what looks
John> like a merge of the mpt2sas and mpt3sas drivers.

Martin> http://git.kernel.org/cgit/linux/kernel/git/mkp/scsi.git/commit/?h=4.4/scsi-queue

Thanks, I'll test that out in a bit.  Now chasing another problem
where the system crashes quickly on bootup.  4.2.x has been stable,
but nothing since 4.3-rc1 has successfully booted up and lasted for
me.

No idea why, and not looking forward to git bisect to try and figure
out since it's my home NFS server with home dirs and other data which
needs to be rebooted to check.


