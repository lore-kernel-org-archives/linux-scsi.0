From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Maximum data size in a single transfer for MS driver
Date: Thu, 25 Feb 2010 12:58:34 -0500
Message-ID: <yq1mxyxkxit.fsf@sermon.lab.mkp.net>
References: <20100225165901.GZ30797@beardog.cce.hp.com>
	<20100225171826.GC30797@beardog.cce.hp.com>
	<yq1vddlkyxo.fsf@sermon.lab.mkp.net> <4B86B666.2070806@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet11.oracle.com ([148.87.113.123]:61889 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932905Ab0BYSAS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Feb 2010 13:00:18 -0500
In-Reply-To: <4B86B666.2070806@panasas.com> (Boaz Harrosh's message of "Thu,
	25 Feb 2010 09:41:58 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, scameron@beardog.cce.hp.com, linux-scsi@vger.kernel.org, James.Bottomley@suse.de, axboe@kernel.dk

>>>>> "Boaz" == Boaz Harrosh <bharrosh@panasas.com> writes:

Boaz> It seems like the confusion calls for a rename. We are made to
Boaz> believe that the accessors naming convention is the same as the
Boaz> queue member it changes. But here it is named as another very
Boaz> confusing member.

Boaz> At least if the name is not changed, a big fat comment is do, that
Boaz> says this is for drivers to change the *max_hw_sectors* though it
Boaz> is named after that other - not for drivers - member.

I'm fine with renaming the function after the hw variant is gone.

-- 
Martin K. Petersen	Oracle Linux Engineering
