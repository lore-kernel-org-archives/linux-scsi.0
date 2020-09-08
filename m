Return-Path: <SRS0=d5MZ=CR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 236A3C43461
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 06:46:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB51C2065E
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 06:46:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="J7ZoHHh1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729103AbgIHGqg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Sep 2020 02:46:36 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:55658 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727898AbgIHGqf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Sep 2020 02:46:35 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0886f5q0009652;
        Mon, 7 Sep 2020 23:46:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=date : from : to :
 cc : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=pfpt0220; bh=aiBLXAOJu8QoseT7V/7qoKu8aO/6blc54o+Ujz+gE7A=;
 b=J7ZoHHh1aZkPbkh4HDHz00gN/SEa2qjAjWwP+oalS5LgEjzQbV7bj8TWSnAu/8Q6Jqhv
 ZJzjStNQaBHPc6OoI80N7Rw/COFu/vq/bu9u9Zb6hFrQ2+UnY9EgsxMKRQgW7iN9OPxL
 pGIA67o+JcEC/ogmRpskzMQptPXdt+7kmh3n1mfyU08zaczTDdqPG3yx/G2ygSarMekx
 poyn6mt4Zc0kvH45BN7LwkGnjU39z/G4aYsD+QeYuv6rjnkQu5uPMhnJAHV5smR/SDdG
 Li/UYmJAk7TzBEgL3Yw1OIa08ikPASMNSOBAdRZMQP2QT4G+sdN1Wcfh7Pn/kfGMkN60 fg== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 33c81ptg73-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 07 Sep 2020 23:46:29 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 7 Sep
 2020 23:46:28 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 7 Sep 2020 23:46:29 -0700
Received: from irv1user01.caveonetworks.com (unknown [10.104.116.179])
        by maili.marvell.com (Postfix) with ESMTP id A97363F703F;
        Mon,  7 Sep 2020 23:46:28 -0700 (PDT)
Received: from localhost (aeasi@localhost)
        by irv1user01.caveonetworks.com (8.14.4/8.14.4/Submit) with ESMTP id 0886kSY3024215;
        Mon, 7 Sep 2020 23:46:28 -0700
X-Authentication-Warning: irv1user01.caveonetworks.com: aeasi owned process doing -bs
Date:   Mon, 7 Sep 2020 23:46:27 -0700
From:   Arun Easi <aeasi@marvell.com>
X-X-Sender: aeasi@irv1user01.caveonetworks.com
To:     Daniel Wagner <dwagner@suse.de>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Nilesh Javali" <njavali@marvell.com>,
        Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v2 3/4] qla2xxx: Drop unused function argument from
 qla2x00_get_sp_from_handle()
In-Reply-To: <20200831161854.70879-4-dwagner@suse.de>
Message-ID: <alpine.LRH.2.21.9999.2009072343130.28578@irv1user01.caveonetworks.com>
References: <20200831161854.70879-1-dwagner@suse.de>
 <20200831161854.70879-4-dwagner@suse.de>
User-Agent: Alpine 2.21.9999 (LRH 334 2019-03-29)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-08_02:2020-09-08,2020-09-08 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 31 Aug 2020, 9:18am, Daniel Wagner wrote:
> 
> Commit 7c3df1320e5e ("[SCSI] qla2xxx: Code changes to support new
> dynamic logging infrastructure.") removed the use of the func
> argument.
> 
> Signed-off-by: Daniel Wagner <dwagner@suse.de>
> ---
>  drivers/scsi/qla2xxx/qla_gbl.h |  3 +--
>  drivers/scsi/qla2xxx/qla_isr.c | 36 ++++++++++++------------------------
>  drivers/scsi/qla2xxx/qla_mr.c  |  9 +++------
>  3 files changed, 16 insertions(+), 32 deletions(-)
> 
--8<--
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
> index 5d278155e4e7..b787643f5031 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -1711,8 +1711,7 @@ qla2x00_process_completed_request(struct scsi_qla_host *vha,
>  }
>  
>  srb_t *
> -qla2x00_get_sp_from_handle(scsi_qla_host_t *vha, const char *func,
> -    struct req_que *req, void *iocb)
> +qla2x00_get_sp_from_handle(scsi_qla_host_t *vha, struct req_que *req, void *iocb)
>  {
>  	struct qla_hw_data *ha = vha->hw;
>  	sts_entry_t *pkt = iocb;

How about printing the "func", which gives an indication of the caller 
function, in the ql_log-s, rather than removing it? At least in the cases 
like you describe, it'd give an indication which handler the path was 
taken.

Regards,
-Arun
