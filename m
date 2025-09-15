Received: from mta-03.yadro.com (mta-03.yadro.com [89.207.88.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80F7331D751;
	Mon, 15 Sep 2025 13:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.207.88.253
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757944061; cv=none; b=Tet3trQiUVyheVClDLVw2oI9DiyJ084cfvadgoYdvNEp7/KLf8BnWqzX38oiLDbZJui3DS27CROnqhmKIrhBrVUPNTvEvoFNT528NXKveiju7m/b/WRmrS8lZvB9unBBgXZD2/Zkk3JToCpKkJ2kDGXnUm2eEisOSRORwDjclNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757944061; c=relaxed/simple;
	bh=f2w5uCDoZFnkYm5uUGJHduCgIY7lNblnEhSehTJXCHA=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PnmxSWpw6Wf3b2tYcMeYWn6ROjrmzZeSCWxBrCXKcS7XVUgRM2iF1zUqW8BIurscPMtD43qE2Z/6RNZ2zXSRQEzTRh1C/wQH+YsEp/SXjFMmOfjPstlBB5t8Zsv7L8cLxWqN/0LgBojSlvdG4XzpVHy1Fc2CMeHGKPluCAVeaVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yadro.com; spf=pass smtp.mailfrom=yadro.com; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=hyvE6Bwl; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=xdYPNGvE; arc=none smtp.client-ip=89.207.88.253
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yadro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yadro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="hyvE6Bwl";
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="xdYPNGvE"
Received: from mta-03.yadro.com (localhost [127.0.0.1])
	by mta-03.yadro.com (Postfix) with ESMTP id C8E83E0005;
	Mon, 15 Sep 2025 16:47:28 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-03.yadro.com C8E83E0005
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-02;
	t=1757944048; bh=Bm7kigw2xKXqAF5dsQZDS5ySRPjJs/2aS/vLrLlSJzU=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:From;
	b=hyvE6BwllkNwVdFU9EKpoof3zfqy3rBvQOq0HAqMo79WY9ffz4xK1Y9Yj5kURgB2d
	 r18kyP9q3YquFir5hlgOgYOUuDTT6uojv8rRjOivfGAFVLXPxcrCNxT6Aqx6TvsoGY
	 sXzDEtLN7bIQBM7bXXZViLygfgeT/gqui/M1O1jgFDNI7xWZqfskZus1qfKtHxywIs
	 EfzpfSFY8BvvgbN7scXWhOkbq5PLRimEpHfbsVktWzyKaHwy0YM44DD74jObjzgayL
	 wA+4dsnu7iKlK2tW0cfT55gBMQp+jBXD5yd13jZfsRKfib6OKcyirA5EHrg3z8GskY
	 dHakkWbnEznVA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-03;
	t=1757944048; bh=Bm7kigw2xKXqAF5dsQZDS5ySRPjJs/2aS/vLrLlSJzU=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:From;
	b=xdYPNGvEd1Q28LFn0yfF++s5yq4M3iTGL7Kw7w+WsxQh2kK5uMCnmkX03NbA87WsB
	 Gb6I1Z9W7aBQ6Vb920EcSu1oDbrK1ilGdGx5aDp1LTRHp30/30D04IRe0i074VRxEH
	 LNZqsEtC8u2IlbGTEvsuV8kvZfS1uOhLyFsMOpe972hDD0AICJCk/aMsHo1AWyjBv4
	 lIQqkDKBsqPKdWdcFDEWEf+YY47dVegHRxGUTC0uPjVtJ3gcjIZA6j3sHDyGZZmRHI
	 hFb3i4pd2yQ110Ovnz3t7SGBu+0WDr+V7cyBonhcixy180F4u8LGfe2Binx2g5jwJ/
	 /K75fDR4cvjqw==
Received: from T-EXCH-10.corp.yadro.com (T-EXCH-10.corp.yadro.com [10.34.9.212])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mta-03.yadro.com (Postfix) with ESMTPS;
	Mon, 15 Sep 2025 16:47:22 +0300 (MSK)
Received: from T-EXCH-12.corp.yadro.com (10.34.9.214) by
 T-EXCH-10.corp.yadro.com (10.34.9.212) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.9; Mon, 15 Sep 2025 16:47:22 +0300
Received: from yadro.com (172.17.34.55) by T-EXCH-12.corp.yadro.com
 (10.34.9.214) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12; Mon, 15 Sep
 2025 16:47:21 +0300
Date: Mon, 15 Sep 2025 16:47:25 +0300
From: Dmitry Bogdanov <d.bogdanov@yadro.com>
To: Tony Battersby <tonyb@cybernetics.com>
CC: Nilesh Javali <njavali@marvell.com>,
	<GR-QLogic-Storage-Upstream@marvell.com>, "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"
	<martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>,
	<target-devel@vger.kernel.org>, <scst-devel@lists.sourceforge.net>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 12/15] scsi: qla2xxx: add cmd->rsp_sent
Message-ID: <20250915134725.GC624@yadro.com>
References: <f8977250-638c-4d7d-ac0c-65f742b8d535@cybernetics.com>
 <366f8fb5-376d-4426-9f27-6bef23a624b2@cybernetics.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <366f8fb5-376d-4426-9f27-6bef23a624b2@cybernetics.com>
X-ClientProxiedBy: RTM-EXCH-06.corp.yadro.com (10.34.9.206) To
 T-EXCH-12.corp.yadro.com (10.34.9.214)
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.1.1.8310, bases: 2025/09/15 10:53:00 #27821131
X-KSMG-AntiVirus-Status: NotDetected, skipped
X-KSMG-KATA-Status: Not Scanned
X-KSMG-LinksScanning: NotDetected
X-KSMG-Message-Action: skipped
X-KSMG-Rule-ID: 5

On Mon, Sep 08, 2025 at 03:07:04PM -0400, Tony Battersby wrote:
> 
> (target mode)
> 
> Add cmd->rsp_sent to indicate that the SCSI status has been sent
> successfully, so that SCST can be informed of any transport errors.
> This will also be used for logging in later patches.
> 
> Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
> ---
>  drivers/scsi/qla2xxx/qla_target.c | 4 ++++
>  drivers/scsi/qla2xxx/qla_target.h | 4 ++++
>  2 files changed, 8 insertions(+)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
> index eabb891a5528..0ddbf02ebe79 100644
> --- a/drivers/scsi/qla2xxx/qla_target.c
> +++ b/drivers/scsi/qla2xxx/qla_target.c
> @@ -4067,6 +4067,10 @@ static void qlt_do_ctio_completion(struct scsi_qla_host *vha,
> 
>         if (cmd->state == QLA_TGT_STATE_PROCESSED) {
>                 cmd->trc_flags |= TRC_CTIO_DONE;
> +
> +               if (likely(status == CTIO_SUCCESS))
> +                       cmd->rsp_sent = 1;

Looks like TRC_CTIO_DONE without TRC_DIF_ERR and TRC_CTIO_ERR means
exactly that CTIO was completed successfully.

> +
>         } else if (cmd->state == QLA_TGT_STATE_NEED_DATA) {
>                 cmd->state = QLA_TGT_STATE_DATA_IN;
> 
> diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
> index 1931e1dade7a..972a7af1c81c 100644
> --- a/drivers/scsi/qla2xxx/qla_target.h
> +++ b/drivers/scsi/qla2xxx/qla_target.h
> @@ -883,6 +883,10 @@ struct qla_tgt_cmd {
>         unsigned int conf_compl_supported:1;
>         unsigned int sg_mapped:1;
>         unsigned int write_data_transferred:1;
> +
> +       /* Set if the SCSI status was sent successfully. */
> +       unsigned int rsp_sent:1;
> +
>         unsigned int q_full:1;
>         unsigned int term_exchg:1;
>         unsigned int cmd_sent_to_fw:1;
> --
> 2.43.0
> 
> 
> 
