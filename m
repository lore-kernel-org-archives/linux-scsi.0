From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [PATCH v3 5/5] lib: scatterlist: move SG pool code from SCSI
 driver to lib/sg_pool.c
Date: Tue, 12 Apr 2016 13:44:06 +0300
Message-ID: <570CD176.9090806@grimberg.me>
References: <1459806491-16428-1-git-send-email-mlin@kernel.org>
 <1459806491-16428-6-git-send-email-mlin@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35949 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756152AbcDLKoK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Apr 2016 06:44:10 -0400
In-Reply-To: <1459806491-16428-6-git-send-email-mlin@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ming Lin <mlin@kernel.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Tejun Heo <tj@kernel.org>

> From: Ming Lin <ming.l@ssi.samsung.com>
>
> Now it's ready to move the mempool based SG chained allocator code from
> SCSI driver to lib/sg_pool.c, which will be compiled only based on a Kconfig
> symbol CONFIG_SG_POOL.
>
> SCSI selects CONFIG_SG_POOL.
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Ming Lin <ming.l@ssi.samsung.com>

Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
