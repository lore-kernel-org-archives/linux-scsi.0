From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH V1] scsi: export function scsi_scan.c:sanitize_inquiry_string
Date: Thu, 28 Jan 2016 17:45:45 -0500
Message-ID: <yq1h9hxs4py.fsf@sermon.lab.mkp.net>
References: <20160128021338.11129.99989.stgit@brunhilda>
	<20160128021625.11129.59242.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:37861 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967672AbcA1WqY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jan 2016 17:46:24 -0500
In-Reply-To: <20160128021625.11129.59242.stgit@brunhilda> (Don Brace's message
	of "Wed, 27 Jan 2016 20:16:26 -0600")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>
Cc: JBottomley@odin.com, Viswas.G@pmcs.com, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, Mahesh.Rajashekhara@pmcs.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com, linux-scsi@vger.kernel.org

>>>>> "Don" == Don Brace <don.brace@pmcs.com> writes:

Don> The hpsa driver uses this function to cleanup inquiry data. Our new
Don> pqi driver will also use this function. This function was copied
Don> into both drivers.

Don> This patch exports sanitize_inquiry_string so the hpsa and the pqi
Don> drivers can use this function directly.

Applied to 4.6/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
