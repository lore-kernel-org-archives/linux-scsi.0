From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 3/9] IB: add a helper to safely drain a QP
Date: Mon, 23 Nov 2015 12:35:44 +0200
Message-ID: <5652EC00.8010705@dev.mellanox.co.il>
References: <1447422410-20891-1-git-send-email-hch@lst.de>
 <1447422410-20891-4-git-send-email-hch@lst.de>
 <564851BB.1020004@dev.mellanox.co.il>
 <564A067B.8030504@opengridcomputing.com>
 <003001d1209c$ecb70760$c6251620$@opengridcomputing.com>
 <564A2270.1040004@dev.mellanox.co.il>
 <003801d120a1$799338d0$6cb9aa70$@opengridcomputing.com>
 <5652EA67.1000707@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:33842 "EHLO
	mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbbKWKft (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Nov 2015 05:35:49 -0500
Received: by wmvv187 with SMTP id v187so153748700wmv.1
        for <linux-scsi@vger.kernel.org>; Mon, 23 Nov 2015 02:35:48 -0800 (PST)
In-Reply-To: <5652EA67.1000707@dev.mellanox.co.il>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>, 'Christoph Hellwig' <hch@lst.de>, linux-rdma@vger.kernel.org
Cc: bart.vanassche@sandisk.com, axboe@fb.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org


> So Maybe we should have:
> void ib_drain_qp(struct ib_qp *qp)

Christoph suggested that this flushing would be taken care
of by rdma_disconnect which sounds even better I think..
