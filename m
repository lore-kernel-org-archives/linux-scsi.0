Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793927912;
	b=m6GaDEDjtkJssLl5vsCVqYl3SjgzwTUE2J7RuYBgNvHNQJi6n1Dq330ag8r17nSYNCxy
	 whTOqJWRqAf1x8V6XNjveEqiteO4V2qZaeYP9wS0uesrJDMJqVkpBWw2DkeKaqUmUtvyK
	 h5kkJXcmyrdM5g2ktuPtYwCCpYZshEFD+h77VtSpICVnekgGNB2ywULcnQv06L6A/mj72
	 EICMgsi9Te5b+5nfgWWO9DMVjQ19To+qe/ihsPnI4pp+v8xFl2pIEgvmrNoTD3hyEtdiS
	 OU8Zo7KmDuLajtY+oi2Yioq3FIHNNirw+Np38xYjS6dLIf6HvJSHT1C342lsMsEfj5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793927912;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=wOibvRAQlrnVP3wBAcT9p78JPzvPBTSjeqvx+35BAKo=;
	b=Cq4VzAOfD/tmQE5vlWZbDlbMx1WAKisE4rtrTVefJTk6AiUc+VlAqtnS788/5aeG9mDl
	 Xm6gimB0CpvncWZPi6anJyzyKvwT4Q1K7FV5QRn76EC2kcKE94E+yC6gJP41Sg9VOU7Xu
	 aH8ItSgJB+eClSQvHP7Zu1X+oldnJWP5DDfoVTD1KfthXOfZUFamoUtTV3hoTnzOzIyVn
	 I4mmoAOp3LwTC1gOjVVuBlET+VzW3gOtRwaZuKcyedf1GWzkubUOnxdoGlW24RerOXo6q
	 5NtJj/ukzfifDiFgqCnN1hHTpJYvfmQhqVNejnTM4enaqGr7mOh/73LYv56gWMC4BOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XmynsxfP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3F2E606A31B
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2026 01:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XmynsxfP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BE461F0089F;
	Fri,  6 Nov 2026 01:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793927911;
	bh=wOibvRAQlrnVP3wBAcT9p78JPzvPBTSjeqvx+35BAKo=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=XmynsxfPYkEObS4skYl9h/VWEeVj5kN1tN9ykjQQgenSXzHGLVyCiBIVP5Ohp0s6P
	 woEj7C8P9i65KoGo8YeVTedvxjiOeTCefdCI6dxGbQbJwaLzb43Im0L+a7mUhUPh6N
	 yPfUMfO4/gSrTI6qGivEST3UFNfTXhRjMbcLXNhG8q28u/N9HpeE5hGtFffLgVSuIH
	 /Ko4ZtekLjQcVjSrv/WLWmW7WXPDGfoYlPgqzBVblJZWNzKU/yGvFS+AJB+XGfyNOK
	 H1HffuepaEeAw+TnY0s700Fll+pxJW0H0MRcKZNn1FnQ8epTrfb085vbWU6qbRc7f+
	 elWN78ki0oCNA==
Message-ID: <sashiko-outbox-200503@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 28/37] scsi: mpt3sas: Replace panic() calls with error
 returns in _config_request
Reply-To: sashiko-reviews@lists.linux.dev
To: "Shivasharan S" <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
In-Reply-To: <1793925772-1303-29-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1793925772-1303-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1793925772-1303-29-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 01:18:30 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] scsi: mpt3sas: corrupted mpi_reply used in NVRAM write after -EIO =
return
--

commit 2d94d7e58bda28658da04f2a639f8f08b1c34536
Author: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

scsi: mpt3sas: Replace panic() calls with error returns in _config_request

This commit replaces four panic() calls in _config_request() triggered by
firmware reply or configuration page-type mismatches with ioc_err() logs
and -EIO error returns.

> diff --git a/drivers/scsi/mpt3sas/mpt3sas_config.c b/drivers/scsi/mpt3sas=
/mpt3sas_config.c
> index 2b5e42255d3b5..271d7dff7c079 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_config.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_config.c
> @@ -416,10 +416,13 @@ _config_request(struct MPT3SAS_ADAPTER *ioc, Mpi2Co=
nfigRequest_t
>  				    smid, "config_request", NULL);
>  			_debug_dump_mf(mpi_request, ioc->request_sz/4);
>  			_debug_dump_reply(mpi_reply, ioc->reply_sz/4);
> -			panic("%s: %s: Firmware BUG: mpi_reply mismatch: Requested PageType(0=
x%02x) Reply PageType(0x%02x)\n",
> -			      ioc->name, __func__,
> -			      mpi_request->Header.PageType & 0xF,
> -			      mpi_reply->Header.PageType & 0xF);
> +			ioc_err(ioc,
> +				"%s: Firmware BUG: mpi_reply mismatch: Requested PageType(0x%02x) Re=
ply PageType(0x%02x)\n",
> +				__func__,
> +				mpi_request->Header.PageType & 0xF,
> +				mpi_reply->Header.PageType & 0xF);
> +			r =3D -EIO;
> +			goto free_mem;
>  		}
> =20
>  		if (((mpi_request->Header.PageType & 0xF) =3D=3D
> @@ -430,10 +433,13 @@ _config_request(struct MPT3SAS_ADAPTER *ioc, Mpi2Co=
nfigRequest_t
>  				    smid, "config_request", NULL);
>  			_debug_dump_mf(mpi_request, ioc->request_sz/4);
>  			_debug_dump_reply(mpi_reply, ioc->reply_sz/4);
> -			panic("%s: %s: Firmware BUG: mpi_reply mismatch: Requested ExtPageTyp=
e(0x%02x) Reply ExtPageType(0x%02x)\n",
> -			      ioc->name, __func__,
> -			      mpi_request->ExtPageType,
> -			      mpi_reply->ExtPageType);
> +			ioc_err(ioc,
> +				"%s: Firmware BUG: mpi_reply mismatch: Requested ExtPageType(0x%02x)=
 Reply ExtPageType(0x%02x)\n",
> +				__func__,
> +				mpi_request->ExtPageType,
> +				mpi_reply->ExtPageType);
> +			r =3D -EIO;
> +			goto free_mem;
>  		}

[Severity: High]
Can returning -EIO here after overwriting mpi_reply cause subsequent
NVRAM writes to target the wrong configuration page?

In _config_request(), the caller's mpi_reply buffer is overwritten before
the PageType and ExtPageType sanity checks run:

	if (ioc->config_cmds.status & MPT3_CMD_REPLY_VALID) {
		memcpy(mpi_reply, ioc->config_cmds.reply,
		    sizeof(Mpi2ConfigReply_t));

Previously, a mismatch here called panic(). With -EIO returned instead,
callers such as mpt3sas_config_set_sas_iounit_pg1() and
_config_set_driver_trigger_pg0() through _config_set_driver_trigger_pg4()
do not check the return value of the MPI2_CONFIG_ACTION_PAGE_WRITE_CURRENT
call before issuing MPI2_CONFIG_ACTION_PAGE_WRITE_NVRAM with the same
mpi_reply:

	mpi_request.Action =3D MPI2_CONFIG_ACTION_PAGE_WRITE_CURRENT;
	_config_request(ioc, &mpi_request, mpi_reply,
	    MPT3_CONFIG_PAGE_DEFAULT_TIMEOUT, config_page, sz);
	mpi_request.Action =3D MPI2_CONFIG_ACTION_PAGE_WRITE_NVRAM;
	r =3D _config_request(ioc, &mpi_request, mpi_reply,
	    MPT3_CONFIG_PAGE_DEFAULT_TIMEOUT, config_page, sz);

When the second _config_request() call begins with a non-NULL config_page,
it copies the header fields from the mismatched mpi_reply into mpi_request:

	if (config_page) {
		mpi_request->Header.PageVersion =3D mpi_reply->Header.PageVersion;
		mpi_request->Header.PageNumber =3D mpi_reply->Header.PageNumber;
		mpi_request->Header.PageType =3D mpi_reply->Header.PageType;
		mpi_request->Header.PageLength =3D mpi_reply->Header.PageLength;
		mpi_request->ExtPageLength =3D mpi_reply->ExtPageLength;
		mpi_request->ExtPageType =3D mpi_reply->ExtPageType;

Wouldn't this send the MPI2_CONFIG_ACTION_PAGE_WRITE_NVRAM request to
firmware with the corrupted page header from the mismatched reply?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/1793925772-1303-1-g=
it-send-email-shivasharan.srikanteshwara@broadcom.com?part=3D28
