Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77339C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Oct 2021 22:22:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B6AE60F39
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Oct 2021 22:22:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239940AbhJZWZG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Oct 2021 18:25:06 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:48484 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239970AbhJZWZF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Oct 2021 18:25:05 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20211026222239epoutp014823a54fd6de36a6477c3267d1822122~xtNNutL3R1364213642epoutp01p
        for <linux-scsi@vger.kernel.org>; Tue, 26 Oct 2021 22:22:39 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20211026222239epoutp014823a54fd6de36a6477c3267d1822122~xtNNutL3R1364213642epoutp01p
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1635286959;
        bh=PUDw3b3dhpgtEnSWeC2mG1IF0mGtTYFA/APwElN0FZ0=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=g7sjsg/N4CgwzDn0xPjzZTZ7iTsbvwlPq8MfMWGnPSgFnb/YjHsIlMxSD/tZO0BHi
         6sLr1tO0Rzt79XvEuoaT+a4QqYN2Ylq2sFFAUx+meHje8EffuE+0g2Umc9eaD5RLMC
         54g/NhCflUgCQkhIqdBGc6MVwhQmR84sejSH+724=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20211026222239epcas2p332bcd33ed8815f9d4b32b60c8ecdd645~xtNNTZl4G1890018900epcas2p3Y;
        Tue, 26 Oct 2021 22:22:39 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.36.99]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4Hf5t363FLz4x9Ps; Tue, 26 Oct
        2021 22:22:35 +0000 (GMT)
X-AuditID: b6c32a45-9b9ff7000000268c-cf-61787fab2659
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        53.A6.09868.BAF78716; Wed, 27 Oct 2021 07:22:35 +0900 (KST)
Mime-Version: 1.0
Subject: RE:(2) [PATCH] scsi: ufs: mark HPB support as BROKEN
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
CC:     Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <679b4d3b-778e-47cd-d53f-f7bf77315f7c@acm.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20211026222235epcms2p75cf431e642eb3134da775d0ff2c8ede5@epcms2p7>
Date:   Wed, 27 Oct 2021 07:22:35 +0900
X-CMS-MailID: 20211026222235epcms2p75cf431e642eb3134da775d0ff2c8ede5
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFJsWRmVeSWpSXmKPExsWy7bCmme7q+opEgznv9CwezNvGZvHy51U2
        i9V3+9kspn34yWzx8pCmxcrVR5ksnqyfxWyxsZ/DYu8tbYvu6zvYLJYf/8fkwO1x+Yq3x7RJ
        p9g8Lp8t9di0qpPNY/fNBjaPj09vsXj0bVnF6PF5k5xH+4FupgDOqGybjNTElNQihdS85PyU
        zLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKBLlRTKEnNKgUIBicXFSvp2NkX5
        pSWpChn5xSW2SqkFKTkF5gV6xYm5xaV56Xp5qSVWhgYGRqZAhQnZGQ9fXmUpWCtdcWvBdqYG
        xnWiXYycHBICJhJnP15j7mLk4hAS2MEosajlCZDDwcErICjxd4cwSI2wgK3E7H3tjCC2kICS
        xPqLs9gh4noStx6uAYuzCehITD9xnx1kjojADEaJ57M6GUEcZoFtTBKn1t9igtjGKzGj/SkL
        hC0tsX35VkaQZZwC1hKXDoRBhDUkfizrZYawRSVurn7LDmO/PzafEcIWkWi9dxaqRlDiwc/d
        UHFJiWO7P0CtqpfYeucX2A0SAj2MEod33mKFSOhLXOvYCHYDr4CvxJnnPWANLAKqEqvO/4Za
        5iIxu/MiWD2zgLzE9rdzwIHCLKApsX6XPogpIaAsceQWC8xXDRthOhFsZgE+iY7Df+HiO+Y9
        gTpNTWLdz/VMExiVZyFCehaSXbMQdi1gZF7FKJZaUJybnlpsVGAIj9zk/NxNjOBEq+W6g3Hy
        2w96hxiZOBgPMUpwMCuJ8F6eV54oxJuSWFmVWpQfX1Sak1p8iNEU6MuJzFKiyfnAVJ9XEm9o
        YmlgYmZmaG5kamCuJM5rKZqdKCSQnliSmp2aWpBaBNPHxMEp1cAkX8C7z6H3V8V0J8unf+0O
        HlLxCeoRW7JmO/daS6W38/13/v6++7MTZ6rK5zclk+XMbE8f/ybx+Sdz/IG+ujtff8f8DV5s
        GD1fQ3hFa1/N5XTHw/0f92jMOFzjwWjZ38UhdkDtVPST388O3zIWnFP+5e9nq0dpsvabo7Ub
        Shklv2+/yFjhIHXexXx/6/9OE1bfsv1Lb8zcXrFgQZGj2NTjSy/MvzR9fX7Q3ZuTikVfiWZu
        X5pw7uaeEvvXvSsCV3603blUP+1jyZ59gUWFKU4BCd1fb3cl53AInZjxe6+9Z2ugxYrwuVaH
        BeRZzosm/X327ZxgYfjSO9tTDTulanNvXX8fvJLFOKLCz/dko9onJZbijERDLeai4kQAWtkv
        gj0EAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20211026201057epcas2p4174ba542fd5abe7ec8f4469f8c60303a
References: <679b4d3b-778e-47cd-d53f-f7bf77315f7c@acm.org>
        <20211026071204.1709318-1-hch@lst.de>
        <99641481-523a-e5a9-db48-dac2b547b4bd@acm.org>
        <7ed11ee1f8beca9a27c0cb2eb0dcea4dbd557961.camel@HansenPartnership.com>
        <870e986c-08dd-2fa2-a593-0f97e10d6df5@kernel.dk>
        <4438ab72-7da0-33de-ecc9-91c3c179eca7@acm.org>
        <c3d85be5-2708-ea50-09ac-2285928bbe0e@kernel.dk>
        <36729509daa80fd48453e8a3a1b5c23750948e6c.camel@HansenPartnership.com>
        <yq1ee873av4.fsf@ca-mkp.ca.oracle.com>
        <CGME20211026201057epcas2p4174ba542fd5abe7ec8f4469f8c60303a@epcms2p7>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

>On 10/26/21 11:27 AM, Martin K. Petersen wrote:
>>> Agreed, that was my initial proposed solution: get rid of the write
>>> buffer optimzation now to fix the API abuse and see if we can add it
>>> back in a more acceptable form later.
>> 
>> Doesn't matter to me whether we back out the 2.0 stuff or mark it as
>> broken. I merely objected to reverting all of HPB since I don't think
>> that would solve anything.
>> 
>> But obviously we'll need a patch to fix 5.15 ASAP...
> 
>I do not have access to a test setup that supports HPB.
> 
>If blk_insert_cloned_request() is moved into the device mapper then I
>think that blk_mq_request_issue_directly() will need to be exported. How
>about the (totally untested) patch below for removing the
>blk_insert_cloned_request() call from the UFS-HPB code?

I will test this code works on real device.

Thanks,
Daejun

> 
>Thanks,
> 
>Bart.
> 
> 
>---
>  block/blk-mq.c            | 1 +
>  block/blk-mq.h            | 1 -
>  drivers/scsi/ufs/ufshpb.c | 2 +-
>  include/linux/blkdev.h    | 1 +
>  4 files changed, 3 insertions(+), 2 deletions(-)
> 
>diff --git a/block/blk-mq.c b/block/blk-mq.c
>index 108a352051be..186321f450f6 100644
>--- a/block/blk-mq.c
>+++ b/block/blk-mq.c
>@@ -2084,6 +2084,7 @@ blk_status_t blk_mq_request_issue_directly(struct request *rq, bool last)
> 
>          return ret;
>  }
>+EXPORT_SYMBOL_GPL(blk_mq_request_issue_directly);
> 
>  void blk_mq_try_issue_list_directly(struct blk_mq_hw_ctx *hctx,
>                  struct list_head *list)
>diff --git a/block/blk-mq.h b/block/blk-mq.h
>index d08779f77a26..ffba52189b18 100644
>--- a/block/blk-mq.h
>+++ b/block/blk-mq.h
>@@ -74,7 +74,6 @@ void blk_mq_insert_requests(struct blk_mq_hw_ctx *hctx, struct blk_mq_ctx *ctx,
>                                  struct list_head *list);
> 
>  /* Used by blk_insert_cloned_request() to issue request directly */
>-blk_status_t blk_mq_request_issue_directly(struct request *rq, bool last);
>  void blk_mq_try_issue_list_directly(struct blk_mq_hw_ctx *hctx,
>                                      struct list_head *list);
> 
>diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
>index 66b19500844e..458eadcb604f 100644
>--- a/drivers/scsi/ufs/ufshpb.c
>+++ b/drivers/scsi/ufs/ufshpb.c
>@@ -547,7 +547,7 @@ static int ufshpb_execute_pre_req(struct ufshpb_lu *hpb, struct scsi_cmnd *cmd,
>                                   read_id);
>          rq->cmd_len = scsi_command_size(rq->cmd);
> 
>-        if (blk_insert_cloned_request(q, req) != BLK_STS_OK)
>+        if (blk_mq_request_issue_directly(req, true) != BLK_STS_OK)
>                  return -EAGAIN;
> 
>          hpb->stats.pre_req_cnt++;
>diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
>index 12b9dbcc980e..f203c7ea205b 100644
>--- a/include/linux/blkdev.h
>+++ b/include/linux/blkdev.h
>@@ -867,6 +867,7 @@ extern int blk_rq_prep_clone(struct request *rq, struct request *rq_src,
>  extern void blk_rq_unprep_clone(struct request *rq);
>  extern blk_status_t blk_insert_cloned_request(struct request_queue *q,
>                                       struct request *rq);
>+blk_status_t blk_mq_request_issue_directly(struct request *rq, bool last);
>  int blk_rq_append_bio(struct request *rq, struct bio *bio);
>  extern void blk_queue_split(struct bio **);
>  extern int blk_queue_enter(struct request_queue *q, blk_mq_req_flags_t flags);
> 
> 
> 
