Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=81.169.146.166
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793367703;
	b=J2sGNrCKl7IEq12xbtzvOm2sVkomUDIphI61JdiZiXQcJwso2mDnwcpYCD9NKXXa0UQV
	 L2u09Ym2/c8vTyhDdZaRJKZoFECEmNDB6jhvIFO1li880LeiF2mPhRNRU3EspikIQRgwR
	 4FaV6YNsjP3wV5IwkG7thEfzdsXLx98Ta+LhicJ/snQVqUSLixW5sAt6aVcCDtIpBHuk4
	 of8rOavtkAIsMUNaP5210m3dYlKL330MGqlqu7ABDIvtMHVRyJNSZ7PAAxJYrup8YTXR+
	 Mio8+SMo+vzSrBAoWO+gdQlA5XS3cwDnAvXv3BRypbl1lB2yIMk8sGu5/ze+n5NtXSw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793367703;
	h=DMARC-Filter:X-RZG-CLASS-ID:DKIM-Signature:DKIM-Signature:X-RZG-AUTH:
	 Received:Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=eoFocFLZvVXbjfcmuUeSDY1L+9vu4B3vE+nKBC2kn5U=;
	b=uBgQEWje8ELArzwYnKDQ4i2D3Q42u2dcQJruvqEvsHvk+WB8UE5+64Y8jDZ5PmT8VHDv
	 tvwm8i7MHuxPw7I9e/xY05b4Atp3TUS2rEuMDAmzd/IsrWS34+F0tdbrTE3iGwdr4ICXg
	 thP6X1B04nNHvBY/sWuxcVw3ail4gEHx+nPPdcDRf+iuirePoBmJBIz0tJDzDTnKg4axv
	 5mMalQlAnHv12pvnp4QjBqYuV0/voFFyJ/RdnZmbVxhZ5RhkRZNmHD/L7ZEw9yyHS62px
	 RmpsSwcxAsqwkB1iWx+aFTvPQ0JvAXAZ4BZkj17mkr82YhCEzPnUKB8jPGlnG5nz2GA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=iokpp.de;
	spf=none smtp.mailfrom=iokpp.de;
	dkim=pass header.d=iokpp.de header.i=@iokpp.de header.a=rsa-sha256 header.s=strato-dkim-0002 header.b=o7awYZnN;
	dkim=pass header.d=iokpp.de header.i=@iokpp.de header.a=ed25519-sha256 header.s=strato-dkim-0003 header.b=UjBo7i28;
	arc=pass header.oldest-pass=0 smtp.remote-ip=81.169.146.166
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [81.169.146.166])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 985BF606A31D;
	Fri, 30 Oct 2026 13:41:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 985BF606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=iokpp.de header.i=@iokpp.de header.a=rsa-sha256 header.s=strato-dkim-0002 header.b=o7awYZnN;
	dkim=pass header.d=iokpp.de header.i=@iokpp.de header.a=ed25519-sha256 header.s=strato-dkim-0003 header.b=UjBo7i28
ARC-Seal: i=1; a=rsa-sha256; t=1793367670; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=DVOMDQUK4jA02A6LX4M7KnttCg1+TxIU6G/YnkbzQzQaz5wJDzG2bWqjsDoGiU/G9l
    Ied32jS/F+wpXvhvCd1eNYXRh/yPEU24hMBXC4SeIfWXDUA8SuFlfk5xbIL9pDSzcgbQ
    5R2rLlgPHCrqxesMzkafltEqXS61tmenZmzIuul0GL+zyNVRyznG+ZhVU/c13qL1EUrF
    G1meQ7KSzIVHn5s/cuCGZYyB7U45y+xTgfTigCTSsKK7VSWgYCg994lCE/RzhGT8TPFd
    9Oe6xq6klq013VJtv2tfvGVJrx+G5NPdVefRj440WSZF+detP9Gog4aeWsjzwEvH8a9f
    9S0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1793367670;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=eoFocFLZvVXbjfcmuUeSDY1L+9vu4B3vE+nKBC2kn5U=;
    b=r3qd/vIMOpVJg8RGeXhBxmPKNtU0iPm0AVa4FRP5Qgmqke9zTde0iTPtzPR1BmVEl/
    JNR53N+cxXmzLRktwn3EbTdDWPxEr2qj96n43DOslpVJjprlyD3cdJj2/sBQrBXB/Zsa
    zYVk6424GLMoL/h0r2KICrf+AIgCfg53lq9Snr88ba5p/C9nVdUyaAHCvU0vRG3ckdkN
    9n+132vddRwTTocJM3O+eymT00c51s1KCJZvRLtdb83VjRiGMzCJsjvpOZ0HkoJa+RMe
    DMy8c9gh7SNIsiJ0KsI6XPQTkzXY07ngKGlyQdhhk6C48ZoM3ko+ZS4RkE7wyw65bMmn
    mX8Q==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1793367670;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=eoFocFLZvVXbjfcmuUeSDY1L+9vu4B3vE+nKBC2kn5U=;
    b=o7awYZnNYwU0BahCQi9Z19d2YUI2sJvPsB8M2aXpB4F8xj6k3HYtD5cMJSezB4eOfC
    oIAfhxHaqb/7ZBEF8eg3Qtoh2n/9BbK/KH4mXuRvQM4oW9YkwaRMY7Tw15ItWepVgtvV
    ZW2uWemINK2x96mh3p3Gf28F2852rYuO1wU2IrbGHP1VTC9ytaUTXa8W4bAa6LebuP5K
    yPnvo/ljPCgnVj8X0+HeZlP6pRj8H/u73+hqFG4T3NpS3MgMlg83iGqgeST9mSTATA/Y
    RzSX17EsnL0IMajSEa00HTihRbOmMf6MN9KovIrW0dxGl03WsDj78yQY6TOBwzIfbAi4
    LZtQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1793367670;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=eoFocFLZvVXbjfcmuUeSDY1L+9vu4B3vE+nKBC2kn5U=;
    b=UjBo7i285Hs7RYht1Uzts0xeZF+trdps3HsFONunY6bWo9PIu7vy1jzUjy0OIpLEl0
    ASt2k34A21sHhN4WT3DA==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0DBslXBtZUxPOub3IZuk"
Received: from [10.176.237.223]
    by smtp.strato.de (RZmta 55.6.3 AUTH)
    with ESMTPSA id z831ad29UDf9UlU
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Fri, 30 Oct 2026 14:41:09 +0100 (CET)
Message-ID: <101b87d76029565d274ae96d66c8a343cab910d3.camel@iokpp.de>
Subject: Re: [PATCH v3] ufs: mcq: fix dev cmd abort path and add OCS poll
 after sq cleanup
From: Bean Huo <beanhuo@iokpp.de>
To: Kiwoong Kim <kwmad.kim@samsung.com>, linux-scsi@vger.kernel.org, 
 linux-kernel@vger.kernel.org, alim.akhtar@samsung.com, avri.altman@wdc.com,
  jejb@linux.ibm.com, martin.petersen@oracle.com, bvanassche@acm.org, 
 kwangwon.min@samsung.com, hy50.seo@samsung.com, cpgs@samsung.com, 
 h10.kim@samsung.com
Cc: stable@vger.kernel.org, stanleyjhu@google.com
Date: Fri, 30 Oct 2026 14:41:08 +0100
In-Reply-To: <20261030111045.982094-1-kwmad.kim@samsung.com>
References: 
	<CGME20261030111051epcas2p225fb4eb84bfbd747782b5641f3831053@epcas2p2.samsung.com>
	 <20261030111045.982094-1-kwmad.kim@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2.1 
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0


Hi Kiwoong,=C2=A0

I think this should be two patches, each needs different fix tag:
=20
On Fri, 2026-10-30 at 20:10 +0900, Kiwoong Kim wrote:
> In MCQ mode, ufshcd_mcq_abort() falls through to ufshcd_try_to_abort_task=
()
> for all timed-out commands. However, device management commands (query, N=
OP)
> use reserved requests and are not SCSI I/O commands. The ABORT TASK task
> management function is designed for SCSI I/O UPIUs and is not applicable =
to
> device management UPIUs.

This is true only since 08b12cda6c44 ("scsi: ufs: core: Switch to
scsi_get_internal_cmd()"), v6.19. Before that, a timed-out query went throu=
gh
ufshcd_wait_for_dev_cmd() -> ufshcd_clear_cmd() and never reached
ufshcd_try_to_abort_task(). you need to add fix tag for it.

>=20
> Fix this by checking ufshcd_is_scsi_cmd() in ufshcd_try_to_abort_task(). =
When
> the request is a reserved (device management) command, skip the TM path a=
nd
> call ufshcd_clear_cmd() directly instead.


> Additionally, extend ufshcd_mcq_sq_cleanup() to poll the OCS field in the
> UTRD of a device management command after a successful SQ_CUS poll. UFSHC=
I
> does not specify the order between the OCS update and the SQ_CUS update, =
so
> OCS may still be stale when cleanup returns. Without this poll, a late
> response to a timed-out query can arrive while a retry is already in flig=
ht,
> leaving the host with two query contexts and raising IS.UTPES.
>=20
> The poll is limited to device management commands because
> ufshcd_compl_one_cqe() copies the OCS from the CQE into the UTRD only for
> them. For SCSI commands, the OCS in the UTRD stays
> OCS_INVALID_COMMAND_STATUS, so polling it would always time out.
>=20
> The poll waits until OCS is no longer OCS_INVALID_COMMAND_STATUS or
> MCQ_POLL_US elapses. -ETIMEDOUT is returned only if OCS is still
> OCS_INVALID_COMMAND_STATUS after the poll. Any other value, such as
> OCS_ABORTED reported by the host controller for the cleaned-up request,
> means the cleanup has completed.
>=20
> --

I didn't understand why here there is "--", this shoudl be "---"?

> Here is the timeline of an actual case for this that happened with kernel
> 6.18.


> 1. The host sent a query but the device didn't respond with it for a long
> time.
>=20
> [ 7384.156142] [4:=C2=A0 kworker/u40:5:10671] exynos-ufs 38300000.ufs:
> ufshcd_mcq_sq_cleanup, hwq 0: cleanup return code (RTC) 0
> [ 7384.156154] [4:=C2=A0 kworker/u40:5:10671] exynos-ufs 38300000.ufs:
> ufshcd_query_flag: Sending flag query for idn 14 failed, err =3D -11
>=20
> 2. So after the query was timed out, the driver did SQ cleanup.
> Then the host updated CQ update and raised IS.CQES,
> Unfortunately, complete() was called the driver's ISR afterward.
>=20
> 3. The driver started to retried the query. In the meantime, it set OCS t=
o
> 0xF.
> Then the driver didn't wait for completion due to the previous complete()
> call,
> and just checked OCS.


this is another patch, and OCS poll patch needs a fixes tag too, for the MC=
Q
abort support.=20


>=20
> [ 7384.156163] [4:=C2=A0 kworker/u40:5:10671] exynos-ufs 38300000.ufs:
> ufshcd_query_flag: Sending flag query for idn 14 failed, err =3D 15
>=20
> 5. The driver retried the query again, but the device didn't return anyth=
ing,
> so the query was also timed-out.
>=20
> [ 7385.660108] [3:=C2=A0 kworker/u40:5:10671] exynos-ufs 38300000.ufs:
> ufshcd_query_flag: Sending flag query for idn 14 failed, err =3D -11
>=20
> 6. A few seconds later, the device returned the response of the 1st query=
,
> but since the host was holding two query contexts and couldn't handle it,
> it raised IS.UTPES.
>=20
> Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
>=20
>=20

Kind regards,=20
Bean
