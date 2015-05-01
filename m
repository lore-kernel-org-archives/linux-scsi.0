From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 7/9] scsi_dh: kill struct scsi_dh_data
Date: Fri, 01 May 2015 11:41:52 -0400
Message-ID: <yq1y4l8tidb.fsf@sermon.lab.mkp.net>
References: <1430415151-30948-1-git-send-email-hch@lst.de>
	<1430415151-30948-8-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25738 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754297AbbEAPoG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 May 2015 11:44:06 -0400
In-Reply-To: <1430415151-30948-8-git-send-email-hch@lst.de> (Christoph
	Hellwig's message of "Thu, 30 Apr 2015 19:32:29 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Mike Snitzer <snitzer@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> Add a ->handler and a ->handler_data field to struct
Christoph> scsi_device and kill this indirection.  Also move struct
Christoph> scsi_device_handler to scsi_dh.h so that changes to it don't
Christoph> require rebuilding every SCSI LLDD.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
