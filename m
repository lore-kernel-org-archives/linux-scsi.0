From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH V6 02/18] scsi: sysfs: don't add scsi_device if its already added
Date: Tue, 30 Sep 2014 17:54:48 -0400
Message-ID: <yq1iok4n593.fsf@sermon.lab.mkp.net>
References: <1411648356-3883-1-git-send-email-draviv@codeaurora.org>
	<1411648356-3883-3-git-send-email-draviv@codeaurora.org>
	<20140926081434.GB22805@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:37228 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754649AbaI3VzW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Sep 2014 17:55:22 -0400
In-Reply-To: <20140926081434.GB22805@infradead.org> (Christoph Hellwig's
	message of "Fri, 26 Sep 2014 01:14:34 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Dolev Raviv <draviv@codeaurora.org>, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, Subhash Jadavani <subhashj@codeaurora.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>

>>>>> "Christoph" == Christoph Hellwig <hch@infradead.org> writes:

>> If LLD has added scsi device (by calling scsi_add_device) before
>> scheduling async scsi_scan_host then scsi_finish_async_scan() will
>> end up calling scsi_sysfs_add_sdev for scsi device which was already
>> added by LLD.  This patch fixes this issue by skipping the call to
>> scsi_sysfs_add_sdev() if it's already visible to rest of the kernel.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
