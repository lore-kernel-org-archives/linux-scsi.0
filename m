Received: from mta-01.yadro.com (mta-01.yadro.com [195.3.219.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3CBA3B8D40;
	Thu, 26 Mar 2026 12:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.3.219.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774527745; cv=none; b=FCVjdl1f0KqONwPGG5SWc/Tn7t9TcX12UgXOozjyQxYb4lqxeRk3+5beUQnvmKpmw8Kxqye9rUGh2zhAvdBSG9V0dk29yXLDGf3VRAsoSjKuQvWXU8QPTtGiNWpalkDB0ivAdrflAdWdPx8wenCwkjL8aULKgq2OvdUQfyha+yQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774527745; c=relaxed/simple;
	bh=15VocTy4o/xxlpnNhqf5BJlz3r0bfkqXV7wtOp/ELIk=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EvQ3s2ZmTzO1tc3sOwo8/gdHbcBEhkZBT7DFCHgYUMnjxtVvkA141S1LlZDCXu71pJF08DEAWlNJxTZK7eM8Sqpkuo7zYcwvSyj4gTZrIXz1ECU3Re6W/PezMh38AxM1tS+Lc7cZmngoCdHWchA1abRmpav98rzHqKvmLn7CJSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yadro.com; spf=pass smtp.mailfrom=yadro.com; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=jhpEcI7Q; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=RDYGKP4e; arc=none smtp.client-ip=195.3.219.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yadro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yadro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="jhpEcI7Q";
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="RDYGKP4e"
Received: from mta-01.yadro.com (localhost [127.0.0.1])
	by mta-01.yadro.com (Postfix) with ESMTP id A2D6220015;
	Thu, 26 Mar 2026 15:16:16 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-01.yadro.com A2D6220015
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-02;
	t=1774527376; bh=FoOP4qebKTXWnvFydCw2Y595nhFLe9ikCfHLVPx27xw=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:From;
	b=jhpEcI7QocnF2J04QrRuhpoS8iR/oHwMDscv3q9kcfPe1ieXmaC48auTaOWOXn0Db
	 tLtvCxU7Zspf03LH8Q+6dY8iBI7nXowPfnnzsRTCl1q76bg/PoDt0z9vPr4eLuEsiE
	 N+9m96IrEfzVyr8hRdfYOCl460ljUO49p4W6xhH9vyDrs2S7Bid78hTaw9onkZoT2r
	 mcz1Y025w9g/JzSbms66+2ry2p7umolyeLgKaT8eLmmScVGSZGwc2e5vysu+SdQtgo
	 6VjPdNB19W32LE/oBGlxmMXbkYMelqGCGTRVz52ycLn2oe/mbsjG9Nu1pIDA/hhabh
	 sjNw4rd9mm9Mg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-03;
	t=1774527376; bh=FoOP4qebKTXWnvFydCw2Y595nhFLe9ikCfHLVPx27xw=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:From;
	b=RDYGKP4ey2GS5JcEEyDTwXN57JkdWmhc+Asf9nzcKJBA0yvUJBC6AAIL6QIYdYjcz
	 gpsO6K5IfNz9F6IzZuGgnFcPzQdISre9iNQeblpcBRswktSBhSFTByEqywugw/BojK
	 +Lp9dO0rgvrmDEndb1SbWhMWG5EU50+nFRkNlFFrJcPStPPGaTp3moYctPOivXFIR+
	 pobZtfSCcUsOXjmnGKX035oWD62J3X7AqJtQvprNDIgoV9mKXO2FIzkqUlf17rjjTd
	 BxYTYnTzqTHsyGCyEjJDEzARlA4BJTQQl3BUHFMi1vaMyVMEYrJpCH4Iq8EKxlGA6t
	 9yA4yD8IlOsaQ==
Received: from RTM-EXCH-06.corp.yadro.com (unknown [10.34.9.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mta-01.yadro.com (Postfix) with ESMTPS;
	Thu, 26 Mar 2026 15:16:13 +0300 (MSK)
Received: from yadro.com (10.34.9.247) by RTM-EXCH-06.corp.yadro.com
 (10.34.9.206) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.35; Thu, 26 Mar
 2026 15:16:14 +0300
Date: Thu, 26 Mar 2026 15:16:14 +0300
From: Dmitry Bogdanov <d.bogdanov@yadro.com>
To: Daniil Dulov <d.dulov@aladdin.ru>
CC: Nilesh Javali <njavali@marvell.com>,
	<GR-QLogic-Storage-Upstream@marvell.com>, "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"
	<martin.petersen@oracle.com>, Tony Battersby <tonyb@cybernetics.com>,
	<linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<lvc-project@linuxtesting.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH] scsi: qla2xxx: Check if target mode enabled in case of
 task management commands
Message-ID: <20260326121614.GA31733@yadro.com>
References: <20260326094249.1366353-1-d.dulov@aladdin.ru>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260326094249.1366353-1-d.dulov@aladdin.ru>
X-ClientProxiedBy: RTM-EXCH-01.corp.yadro.com (10.34.9.201) To
 RTM-EXCH-06.corp.yadro.com (10.34.9.206)
X-KSMG-AntiPhishing: NotDetected, bases: 2026/03/26 12:00:00
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.1.1.8310, bases: 2026/03/26 09:27:00 #28335688
X-KSMG-AntiVirus-Status: NotDetected, skipped
X-KSMG-KATA-Status: Not Scanned
X-KSMG-LinksScanning: NotDetected, bases: 2026/03/26 12:00:00
X-KSMG-Message-Action: skipped
X-KSMG-Rule-ID: 5

On Thu, Mar 26, 2026 at 12:42:49PM +0300, Daniil Dulov wrote:
> 
> TYPE_TGT_TMCMD are not being skipped now, but tgt_ops are dereferenced
> in qlt_free_ul_cmd() without checking if target mode is enabled. However,
> it is possible that commands requiring target mode to be enabled are

Is is really possible? TYPE_TGT_TMCMD is allocated using tgt_ops
pointer. So at creation time tgt_ops was a valid.

> received while target mode is disabled as it is seen in TYPE_TGT_CMD case.

That condition in TYPE_TGT_CMD is also some legacy leftover.

Race condition when tgt_ops might be get nulled during HBA reset was fixed in
https://lore.kernel.org/all/20210415203554.27890-1-d.bogdanov@yadro.com/

> To fix the issue check if target mode is enabled in TYPE_TGT_TMCMD
> case as well.
> 
> Fixes: d46c69a087aa ("scsi: qla2xxx: Clear cmds after chip reset")
> Cc: stable@vger.kernel.org
> Signed-off-by: Daniil Dulov <d.dulov@aladdin.ru>
> ---
>  drivers/scsi/qla2xxx/qla_os.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index 72b1c28e4dae..e81ef3629aaa 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -1890,6 +1890,13 @@ __qla2x00_abort_all_cmds(struct qla_qpair *qp, int res)
>                                 }
>                                 break;
>                         case TYPE_TGT_TMCMD:
> +                               if (!vha->hw->tgt.tgt_ops || !tgt ||
> +                                   qla_ini_mode_enabled(vha)) {
> +                                       ql_dbg(ql_dbg_tgt_mgt, vha, 0xf004,
> +                                           "HOST-ABORT-HNDLR: dpc_flags=%lx. Target mode disabled\n",
> +                                           vha->dpc_flags);
> +                                       continue;
> +                               }
>                                 /*
>                                  * Currently, only ABTS response gets on the
>                                  * outstanding_cmds[]
> --
> 2.34.1
> 
