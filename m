From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: completion queue abstraction V2
Date: Tue, 29 Dec 2015 10:51:13 +0100
Message-ID: <56825791.9040709@sandisk.com>
References: <1449521512-22921-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0079.outbound.protection.outlook.com ([65.55.169.79]:39648
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751160AbbL2JvT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Dec 2015 04:51:19 -0500
In-Reply-To: <1449521512-22921-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-rdma@vger.kernel.org
Cc: sagig@dev.mellanox.co.il, bart.vanassche@sandisk.com, axboe@fb.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On 12/07/2015 09:51 PM, Christoph Hellwig wrote:
> This series adds a new RDMA core abstraction that insulated the
> ULPs from the nitty gritty details of CQ polling.  See the individual
> patches for more details.

Hello Christoph,

After having tested the SRP initiator and target drivers with this patch 
series applied I have further feedback about this patch series. I will 
provide that feedback as replies to the individual patches.

Bart.
