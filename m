From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Linux kernels 4.3+ mess up MPT2SAS configs
Date: Thu, 03 Dec 2015 09:36:54 -0500
Message-ID: <yq1lh9ba9a1.fsf@sermon.lab.mkp.net>
References: <22112.13937.759625.629277@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28286 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553AbbLCOhB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Dec 2015 09:37:01 -0500
In-Reply-To: <22112.13937.759625.629277@quad.stoffel.home> (John Stoffel's
	message of "Thu, 3 Dec 2015 07:32:49 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, nagalakshmi.nandigama@avagotech.com, praveen.krishnamoorthy@avagotech.com, sreekanth.reddy@avagotech.com

>>>>> "John" == John Stoffel <john@stoffel.org> writes:

John> I've got an LSI MPT2SAS controller in my home system, great board,
John> running well.  When I try to use kernels newer than approximately
John> 4.3.0, the default Kconfig entry goes away because of what looks
John> like a merge of the mpt2sas and mpt3sas drivers.

http://git.kernel.org/cgit/linux/kernel/git/mkp/scsi.git/commit/?h=4.4/scsi-queue

-- 
Martin K. Petersen	Oracle Linux Engineering
