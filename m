From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 5/9] srpt: use the new CQ API
Date: Tue, 17 Nov 2015 11:38:48 -0800
Message-ID: <564B8248.7050407@sandisk.com>
References: <1447422410-20891-1-git-send-email-hch@lst.de>
 <1447422410-20891-6-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0055.outbound.protection.outlook.com ([207.46.100.55]:14848
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932245AbbKQTiw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Nov 2015 14:38:52 -0500
In-Reply-To: <1447422410-20891-6-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-rdma@vger.kernel.org
Cc: sagig@dev.mellanox.co.il, bart.vanassche@sandisk.com, axboe@fb.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On 11/13/2015 05:46 AM, Christoph Hellwig wrote:
> [ ... ]

This patch contains two logical changes:
- Conversion to the new CQ API.
- Removal of the ib_srpt_compl thread.

Had it been considered to implement these changes as two separate patches ?

Thanks,

Bart.
