From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 1/3] scsi_cmnd: Introduce scsi_transfer_length helper
Date: Wed, 11 Jun 2014 19:39:07 -0400
Message-ID: <yq14mzrrp7o.fsf@sermon.lab.mkp.net>
References: <1402477799-24610-1-git-send-email-sagig@mellanox.com>
	<1402477799-24610-2-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18915 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244AbaFKXjn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jun 2014 19:39:43 -0400
In-Reply-To: <1402477799-24610-2-git-send-email-sagig@mellanox.com> (Sagi
	Grimberg's message of "Wed, 11 Jun 2014 12:09:57 +0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>
Cc: michaelc@cs.wisc.edu, martin.petersen@oracle.com, nab@linux-iscsi.org, roland@kernel.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-rdma@vger.kernel.org

>>>>> "Sagi" == Sagi Grimberg <sagig@mellanox.com> writes:

Sagi> In case protection information exists on the wire scsi transports
Sagi> should include it in the transfer byte count (even if protection
Sagi> information does not exist in the host memory space). This helper
Sagi> will compute the total transfer length from the scsi command data
Sagi> length and protection attributes.

Looks good!

-- 
Martin K. Petersen	Oracle Linux Engineering
