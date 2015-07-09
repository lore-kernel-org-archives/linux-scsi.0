From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: Fix sense information setting in fixed sized format
Date: Thu, 09 Jul 2015 12:27:56 -0400
Message-ID: <yq1io9ts3cj.fsf@sermon.lab.mkp.net>
References: <1436367603-16456-1-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:29536 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbbGIQ20 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jul 2015 12:28:26 -0400
In-Reply-To: <1436367603-16456-1-git-send-email-sagig@mellanox.com> (Sagi
	Grimberg's message of "Wed, 8 Jul 2015 18:00:03 +0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>

>>>>> "Sagi" == Sagi Grimberg <sagig@mellanox.com> writes:

Sagi> In fixed size sense format the information field is a four byte
Sagi> field.

Correct.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
