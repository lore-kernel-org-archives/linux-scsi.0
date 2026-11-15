Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794746384;
	b=GazXwEeflbgpwuXuI6ovTQwwsn9rwTFdcHd+Yq2UeA/UdkjOej+YyPW7853nvyekCI7m
	 POFaRGLud/rVrzAcnJfz0EtqB5XQLtkty9yrXTwt6Ei5xmAmnoxG/+4lGXwN5LXJY1VRJ
	 Vqx0b7gHYMNqCana5XhB4arZCKrupNmLpAAZm4NpxB4iDj0edGVnuQ1z+TOF8iwoyOuBx
	 SpOkltBR0hRZaqZh49vkdi7Gjfc7WnYLHrxCBixfLIC3wjXZdfo7AOoCrifwcQw+TxlK3
	 Fio2kSehBMMZgI96HZ+RzZLgjG+rOwEUFYRGPuOekv20KJYWLhJ0SzDdrGJp+mssmfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794746384;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=CRItSjwHOnyId7JXolyz4ODCP/NlRPi7Yg5NVk9Wa/U=;
	b=zE9K21lepYLf6890eEAQUbHDNb9w04fm9tySIKu5NPJ69A3hKX+44Ax7fvDRIln2kqA6
	 +Uv3sg0ZkQ9rpgVS4Mij51Tv4jowCJ/cltD7qRi0v38XPb4Ovx0vpx2YafxXbbEmTqWQg
	 mYDsWWumMMwYlhbpc0a9GIdbh0RW7FIhOd64ECU/mxU/4FktVIPitMncn/ZVOlMdoZMV2
	 K8qMoZrcpocGTCt7Y3ngjNIs/8MeRxmzcK+AebuyUGhPnJREMA4kTjOoxGwoEuBu5mPcT
	 TjcMeuxwfCUixdKj0wLLtzyYhSsK1IDI5BTVIlLT/edtFRtPEqJQk0noBIPU7YDmC1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FM8BlruS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 630A7606A31A
	for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2026 12:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FM8BlruS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 189EE1F000C4;
	Sun, 15 Nov 2026 12:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794746384;
	bh=CRItSjwHOnyId7JXolyz4ODCP/NlRPi7Yg5NVk9Wa/U=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FM8BlruScR8gs6gay2HEjg8UEwRdpZL5gOjI6W0FkgHpY5J7JYye4buieMrw8vwKF
	 dmOo/Jh8Ufev8I/ZcAwCbl86no9csiV8lnkvF7Vm17i5P2PaqukLTLqUGk7EdOqnx5
	 R0Zc3GxHbAAR/pGtlNOOhRnbeRdccBeUP0g4Bu+lfQktHXyUzygaIlDryW+ijxDEtN
	 MenB+r6zvSepnCo8/T/RAVr61DvK+LD7Pno6yUI1AsiA05NbMyO6Meni8IM1Kq5e28
	 7NqAcw7WOe93m0n7f56ACKP0lSbNYI8bgA2Xr9V8/fPyoOIm3iXRjGw8vPhD3EgKc4
	 +Q4u4nu5J2OMQ==
Message-ID: <sashiko-outbox-215502@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/3] scsi: mvumi: quarantine a timed-out internal
 command's buffers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261115122153.1446810-3-yhlee@isslab.korea.ac.kr>
References: <20261115122153.1446810-1-yhlee@isslab.korea.ac.kr>
 <20261115122153.1446810-3-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 15 Nov 2026 12:39:43 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] scsi: mvumi: stranded mhba_dev_list entries when
  mvumi_probe_devices() aborts
--

commit b1478e67683e6d020afcb1ac3f2ae79623c98cd3
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

scsi: mvumi: quarantine a timed-out internal command's buffers

This commit moves the DMA buffers of timed-out internal commands onto
mhba->res_list instead of freeing them immediately, and stops the target
scan loop in mvumi_probe_devices() when an inquiry command times out.

> diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
> index 8d22d370d8608..48652640afc18 100644
> --- a/drivers/scsi/mvumi.c
> +++ b/drivers/scsi/mvumi.c
[ ... ]
> @@ -1552,6 +1584,7 @@ static int mvumi_probe_devices(struct mvumi_hba *mh=
ba)
>  	struct mvumi_device *mv_dev =3D NULL;
>  	struct mvumi_cmd *cmd =3D NULL;
>  	int found =3D 0;
> +	int ret;
> =20
>  	cmd =3D mvumi_create_internal_cmd(mhba, 64);
>  	if (!cmd)
> @@ -1564,6 +1597,11 @@ static int mvumi_probe_devices(struct mvumi_hba *m=
hba)
> =20
>  	for (id =3D 0; id < maxid; id++) {
>  		wwid =3D mvumi_inquiry(mhba, id, cmd);
> +		/* the controller still owns this command's buffers */
> +		if (cmd->timed_out) {
> +			ret =3D -1;
> +			goto out;
> +		}

[Severity: Medium]
Does aborting the loop here strand struct mvumi_device entries allocated
for earlier target IDs on mhba->mhba_dev_list?

When an earlier iteration finds a new target, mvumi_probe_devices()
removes any prior entry from mhba->shost_dev_list and appends a new
struct mvumi_device to mhba->mhba_dev_list.  If a later target ID times
out and returns -1, mvumi_rescan_bus() skips draining mhba->mhba_dev_list:

drivers/scsi/mvumi.c:mvumi_rescan_bus() {
	...
		ret =3D mvumi_probe_devices(mhba);
		if (!ret) {
			list_for_each_entry_safe(mv_dev, dev_next,
						 &mhba->mhba_dev_list, list) {
	...
}

Because mvumi_match_devices() and mvumi_remove_devices() only inspect
mhba->shost_dev_list, a later rescan will allocate duplicate entries on
mhba->mhba_dev_list for those earlier targets or bring stale entries
online if a target disappeared in the meantime.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261115122153.1446=
810-1-yhlee@isslab.korea.ac.kr?part=3D2
