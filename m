Received: from mta-01.yadro.com (mta-01.yadro.com [195.3.219.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B230242D89;
	Thu,  9 Apr 2026 09:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.3.219.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775727138; cv=none; b=WdnRax07M7w1pCWkhFZs90zMdvd9Ay5TKYB8n+tiQrhGK27mQXhywz1xwH4BBAMaSmE3umRTJ8czYEiV3CLxkXa1OZTCrJJUqmbxGVPnKD+JH6ApEQom4yPp5cCgLqpLexwFUBpszHcYn4HmBJZ/8frLFjWTuMwFsaJ5k100K1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775727138; c=relaxed/simple;
	bh=4I2hbFVPDgIbdKcpWGKHICWSswjqPRxlZWU0x2S/vgk=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qpgwrt8HIx86l4cuwV/YSQrRCyIH9KYIhj0sqbpHrPn5ZtJeV6L0yzzViKjxqiGbloDnnEDc9QIp7bkWdGOiRGZPTXUNY6U4LPsyCSCmJoBkOcyoqCjvBjMQ/3BrMIlzCf/lfhNgadF1Oi53pY8IoHVnjQ8hvt1Xb73ZYk7BrkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yadro.com; spf=pass smtp.mailfrom=yadro.com; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=xdkT9mPj; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=A/wqktW9; arc=none smtp.client-ip=195.3.219.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yadro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yadro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="xdkT9mPj";
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="A/wqktW9"
Received: from mta-01.yadro.com (localhost [127.0.0.1])
	by mta-01.yadro.com (Postfix) with ESMTP id 701DC20002;
	Thu,  9 Apr 2026 12:31:52 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-01.yadro.com 701DC20002
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-02;
	t=1775727112; bh=CaijfPOWPMeAVWc1tGnKZr7iCZ1kjxhZMCIoyWZse0o=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:From;
	b=xdkT9mPj8qvUpUmdlTTTpw61Gt29YSprbwKbWWpe264zWhiRlFOar7HsAFq6sY8vB
	 2SKJbwk1pbZVevkYExNNubvUy1niGa5z3E20xA2pprPqwbVuJQwbHPUiLmkeSPMBG6
	 F20pcHPEJaLTOtecSr7oaOdJGDzKvMnyKsL06lBD19syNMIpuXmH9VOKJqix3R/9qV
	 uiQNl+2TICbuMeJxA8/aApqU7WPpv7X4gOxv1LC3Dua1hRpcMu8TTDq5tpL4n48X+9
	 OxY0TSRYchtUbVO+bthI4h8AUpBNIjF5Ll+JzjWPVSOCatPPCXAlifX0b17SSKW/Mo
	 uYeSNFQ413yng==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-03;
	t=1775727112; bh=CaijfPOWPMeAVWc1tGnKZr7iCZ1kjxhZMCIoyWZse0o=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:From;
	b=A/wqktW9OuAG3wVQ4kxTaZjhZ2H8NAe6fSl+hNnn8zdcHwwN8VFgeVtibHXLQmU0r
	 F4lofBLK47YwoMReVH2H6RVXDL6FYh9SbxoZA3DzOOLFkIGyUeNtYCDCVIQAM6NivW
	 igdCM7PtkQ/TCi0uB78+8YQM1aeLI83Rmj3U/NRxmAPz9zVUslv8HRmYU3/pNAg4JL
	 XKR6DGYy4U8KwmIxXJOXS0b4ITVedUZstyFDWHvheOdTJOgKdPOUEHPiEy2/upvvKN
	 sykz4fnmqcUdM8pU7q1D3FSOSxBTR4hnqCtOsrHaBqAmizs8lKRnqbAY2dT2l6d1fl
	 HgcSoKIiXnySQ==
Received: from RTM-EXCH-06.corp.yadro.com (unknown [10.34.9.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mta-01.yadro.com (Postfix) with ESMTPS;
	Thu,  9 Apr 2026 12:31:50 +0300 (MSK)
Received: from yadro.com (10.34.9.247) by RTM-EXCH-06.corp.yadro.com
 (10.34.9.206) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.35; Thu, 9 Apr
 2026 12:31:59 +0300
Date: Thu, 9 Apr 2026 12:31:59 +0300
From: Dmitry Bogdanov <d.bogdanov@yadro.com>
To: <carlos.bilbao@kernel.org>
CC: <bilbao@vt.edu>, <martin.petersen@oracle.com>, <kees@kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v2] scsi: target: iscsi: reject invalid size Extended CDB
 AHS
Message-ID: <20260409093159.GA902@yadro.com>
References: <20260404014429.115807-1-carlos.bilbao@kernel.org>
 <20260409024253.34926-1-carlos.bilbao@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260409024253.34926-1-carlos.bilbao@kernel.org>
X-ClientProxiedBy: RTM-EXCH-05.corp.yadro.com (10.34.9.205) To
 RTM-EXCH-06.corp.yadro.com (10.34.9.206)
X-KSMG-AntiPhishing: NotDetected
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.1.1.8310, bases: 2026/04/09 08:27:00 #28381071
X-KSMG-AntiVirus-Status: NotDetected, skipped
X-KSMG-KATA-Status: Not Scanned
X-KSMG-LinksScanning: NotDetected
X-KSMG-Message-Action: skipped
X-KSMG-Rule-ID: 5

On Wed, Apr 08, 2026 at 07:42:53PM -0700, carlos.bilbao@kernel.org wrote:
> 
> From: Carlos Bilbao <carlos.bilbao@kernel.org>
> 
> If ecdb_ahdr->ahslength is zero, two bugs follow:
> 
>   kmalloc(be16_to_cpu(ecdb_ahdr->ahslength) + 15, ...)
> 
> allocates 15 bytes, but the immediately following memcpy writes
> ISCSI_CDB_SIZE (16) bytes into it, a one-byte heap overflow. Also:
> 
>   memcpy(cdb + ISCSI_CDB_SIZE, ecdb_ahdr->ecdb,
>            be16_to_cpu(ecdb_ahdr->ahslength) - 1);
> 
> (u16)0 - 1 promotes to (int)-1 which converts to SIZE_MAX as size_t,
> causing a massive out-of-bounds write.
> 
> Reject ahslength == 0 with ISCSI_REASON_PROTOCOL_ERROR before the kmalloc.
> Also reject ahslength values that exceed the actual AHS buffer advertised.
> 
> Changes in v2:
> 
> - Add bounds check: ahslength must not exceed (hdr->hlength * 4) - 3.
> - Replace opaque ahslength + 15 with explicit cdb_length variable.
> 
> Fixes: 8f1f7d297bce ("scsi: target: iscsi: Add support for extended CDB AHS")
> Signed-off-by: Carlos Bilbao (Lambda) <carlos.bilbao@kernel.org>

Reviewed-by: Dmitry Bogdanov <d.bogdanov@yadro.com>

> ---
>  drivers/target/iscsi/iscsi_target.c | 23 +++++++++++++++++++----
>  1 file changed, 19 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
> index e80449f6ce15..1a492965ebdf 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -1100,6 +1100,8 @@ int iscsit_setup_scsi_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
>         cdb = hdr->cdb;
> 
>         if (hdr->hlength) {
> +               u16 ahslength;
> +
>                 ecdb_ahdr = (struct iscsi_ecdb_ahdr *) (hdr + 1);
>                 if (ecdb_ahdr->ahstype != ISCSI_AHSTYPE_CDB) {
>                         pr_err("Additional Header Segment type %d not supported!\n",
> @@ -1108,14 +1110,27 @@ int iscsit_setup_scsi_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
>                                 ISCSI_REASON_CMD_NOT_SUPPORTED, buf);
>                 }
> 
> -               cdb = kmalloc(be16_to_cpu(ecdb_ahdr->ahslength) + 15,
> -                             GFP_KERNEL);
> +               ahslength = be16_to_cpu(ecdb_ahdr->ahslength);
> +               if (!ahslength) {
> +                       pr_err("Extended CDB AHS with zero length, protocol error.\n");
> +                       return iscsit_add_reject_cmd(cmd,
> +                               ISCSI_REASON_PROTOCOL_ERROR, buf);
> +               }
> +               if (ahslength > (hdr->hlength * 4) - 3) {
> +                       pr_err("Extended CDB AHS length %u exceeds available buffer.\n",
> +                              ahslength);
> +                       return iscsit_add_reject_cmd(cmd,
> +                               ISCSI_REASON_PROTOCOL_ERROR, buf);
> +               }
> +
> +               u16 cdb_length = ahslength - 1 + ISCSI_CDB_SIZE;

AFAIK, a variable declarationis allowed to be in the beginning of code block only.

> +
> +               cdb = kmalloc(cdb_length, GFP_KERNEL);
>                 if (cdb == NULL)
>                         return iscsit_add_reject_cmd(cmd,
>                                 ISCSI_REASON_BOOKMARK_NO_RESOURCES, buf);
>                 memcpy(cdb, hdr->cdb, ISCSI_CDB_SIZE);
> -               memcpy(cdb + ISCSI_CDB_SIZE, ecdb_ahdr->ecdb,
> -                      be16_to_cpu(ecdb_ahdr->ahslength) - 1);
> +               memcpy(cdb + ISCSI_CDB_SIZE, ecdb_ahdr->ecdb, cdb_length - ISCSI_CDB_SIZE);
>         }
> 
>         data_direction = (hdr->flags & ISCSI_FLAG_CMD_WRITE) ? DMA_TO_DEVICE :
> --
> 2.43.0
> 
