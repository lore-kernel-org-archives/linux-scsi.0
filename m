From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [Lsf] LSF/MM Schedule and improving discard support
Date: Wed, 13 Apr 2016 13:13:24 -0400
Message-ID: <yq1lh4hv3d7.fsf@sermon.lab.mkp.net>
References: <57067F19.3030404@sandisk.com>
	<1460044289.2311.5.camel@linux.vnet.ibm.com>
	<570E6C55.1060003@sandisk.com> <yq11t69wkcl.fsf@sermon.lab.mkp.net>
	<570E73D5.3010502@sandisk.com> <yq1twj5v4qs.fsf@sermon.lab.mkp.net>
	<570E7A6F.5040206@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49054 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558AbcDMRNj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Apr 2016 13:13:39 -0400
In-Reply-To: <570E7A6F.5040206@sandisk.com> (Bart Van Assche's message of
	"Wed, 13 Apr 2016 09:57:19 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, James Bottomley <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Jens Axboe <axboe@fb.com>, "lsf@lists.linux-foundation.org" <lsf@lists.linux-foundation.org>

>>>>> "Bart" == Bart Van Assche <bart.vanassche@sandisk.com> writes:

Bart> And if so, how should this code behave and if sector and/or
Bart> nr_sectors is not a multiple of sdp->sector_size? As one can see
Bart> the above code rounds down sector and nr_sectors while converting
Bart> from sectors to logical blocks. This means that if a non-aligned
Bart> BLKDISCARD is submitted from user space that one or more sectors
Bart> *before* the start of the range specified in the ioctl will be
Bart> discarded. Isn't that a bug?

Yes. But Darrick already addressed that, I believe.

-- 
Martin K. Petersen	Oracle Linux Engineering
