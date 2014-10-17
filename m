From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: PC partition tables are little endian
Date: Fri, 17 Oct 2014 19:47:25 -0400
Message-ID: <yq161fi2r8y.fsf@sermon.lab.mkp.net>
References: <1412188261-29632-1-git-send-email-hch@lst.de>
	<20141017131349.GB16538@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45553 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369AbaJQXr5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Oct 2014 19:47:57 -0400
In-Reply-To: <20141017131349.GB16538@infradead.org> (Christoph Hellwig's
	message of "Fri, 17 Oct 2014 06:13:50 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Douglas Gilbert <dgilbert@interlog.com>

>>>>> "Christoph" == Christoph Hellwig <hch@infradead.org> writes:

>> As sparse correctly pointed out scsi_partsize should use
>> get_unaligned_le32 to read PC partition tables from disk, as they are
>> little endian.
>> 
>> The result of this bug is that we returned incorrect geometries on
>> big endian systems when using the scsicam variant.  Which probably
>> doesn't matter as only old x86 systems every cared about the
>> geometry.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
