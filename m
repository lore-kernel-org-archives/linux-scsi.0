From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 14/20] scsi_dh_alua: parse target device id
Date: Fri, 24 Jul 2015 11:28:21 -0400
Message-ID: <yq1io99y3qi.fsf@sermon.lab.mkp.net>
References: <1436346378-96518-1-git-send-email-hare@suse.de>
	<1436346378-96518-15-git-send-email-hare@suse.de>
	<20150724150740.GB29434@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:19122 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbbGXP2d (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Jul 2015 11:28:33 -0400
In-Reply-To: <20150724150740.GB29434@lst.de> (Christoph Hellwig's message of
	"Fri, 24 Jul 2015 17:07:40 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> Can you move this to scsi_mod.ko?  I'll need the same code
Christoph> for the NFS SCSI layout driver soon.

Same here. Working on copy offload again.

-- 
Martin K. Petersen	Oracle Linux Engineering
