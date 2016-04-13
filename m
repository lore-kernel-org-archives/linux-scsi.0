From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: LSF/MM Schedule and improving discard support
Date: Wed, 13 Apr 2016 09:29:09 -0700
Message-ID: <570E73D5.3010502@sandisk.com>
References: <57067F19.3030404@sandisk.com>
 <1460044289.2311.5.camel@linux.vnet.ibm.com> <570E6C55.1060003@sandisk.com>
 <yq11t69wkcl.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0058.outbound.protection.outlook.com ([207.46.100.58]:22675
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754556AbcDMQ3R (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Apr 2016 12:29:17 -0400
In-Reply-To: <yq11t69wkcl.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <jejb@linux.vnet.ibm.com>, Jens Axboe <axboe@fb.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "lsf@lists.linux-foundation.org" <lsf@lists.linux-foundation.org>, "Darrick J. Wong" <darrick.wong@oracle.com>

On 04/13/2016 09:21 AM, Martin K. Petersen wrote:
> From a filesystem/ioctl perspective, BLKDISCARD is a hint. We should not be
> rounding off or aligning anything.

Hello Martin,

Today if a BLKDISCARD ioctl passes a non-aligned start and/or end sector 
to the kernel then the block layer will submit invalid (non-aligned) 
REQ_DISCARD requests to the block driver the ioctl applies to. This is 
not acceptable. Does the above mean that you are proposing to fail such 
BLKDISCARD ioctls with an error code?

Thanks,

Bart.

