From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 5/9] scsi_dh: integrate into the core SCSI code
Date: Fri, 01 May 2015 11:36:57 -0400
Message-ID: <yq17fssux5y.fsf@sermon.lab.mkp.net>
References: <1430415151-30948-1-git-send-email-hch@lst.de>
	<1430415151-30948-6-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23114 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754079AbbEAPjM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 May 2015 11:39:12 -0400
In-Reply-To: <1430415151-30948-6-git-send-email-hch@lst.de> (Christoph
	Hellwig's message of "Thu, 30 Apr 2015 19:32:27 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Mike Snitzer <snitzer@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> Stop building scsi_dh as a separate module and integrate it
Christoph> fully into the core SCSI code with explicit callouts at bus
Christoph> scan time.  For now the callouts are placed at the same point
Christoph> as the old bus notifiers were called, but in the future we
Christoph> will be able to look at ALUA INQUIRY data earlier on.

Christoph> Note that this also means that the device handler modules
Christoph> need to be loaded by the time we scan the bus.  The next
Christoph> patches will add support for autoloading device handlers at
Christoph> bus scan time to make sure they are always loaded if they are
Christoph> enabled in the kernel config.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
