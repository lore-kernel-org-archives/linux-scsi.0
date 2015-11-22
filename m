From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 2/9] IB: add a proper completion queue abstraction
Date: Sun, 22 Nov 2015 11:51:13 +0200
Message-ID: <56519011.6060204@dev.mellanox.co.il>
References: <1447422410-20891-1-git-send-email-hch@lst.de>
 <1447422410-20891-3-git-send-email-hch@lst.de> <564B697A.2020601@sandisk.com>
 <564C2F01.6020407@dev.mellanox.co.il> <564CC15E.7030602@sandisk.com>
 <20151120101644.GC24298@lst.de> <564F4F38.9040505@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:38632 "EHLO
	mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318AbbKVJvS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Nov 2015 04:51:18 -0500
Received: by wmec201 with SMTP id c201so70469522wme.1
        for <linux-scsi@vger.kernel.org>; Sun, 22 Nov 2015 01:51:17 -0800 (PST)
In-Reply-To: <564F4F38.9040505@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@lst.de>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>


> Hello Christoph,
>
> The comment about locality in the above quote is interesting. How about
> modifying patch 2/9 as indicated below ? The modification below does not
> change the behavior of this patch if ib_cq.w.cpu is not modified. And it
> allows users who care about locality and who want to skip the scheduler
> overhead by setting ib_cq.w.cpu to the index of the CPU they want the
> work to be processed on.

That sounds acceptable...
