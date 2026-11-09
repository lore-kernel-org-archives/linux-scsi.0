Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794218992;
	b=QFMb6P7Mlcwjrs/rJxd1YYAvwnFcWc5bAmU/kg/NBgkaeCCIQMYHxSLkcRuL+7aqqkX/
	 ghgHruPTvKtz0SX+bAF+cwnjVkfHtU0HHKOHd+mEpLMAAcCpLl+HmDa6cqk8jotKXMoL1
	 HwejkfSkZmm8xMcMVrG7RA3lQn7l8BEWqpFI8QUIn7khlyFk/riAIyIVgYKIlTwAR8UxZ
	 VzjSR9cShMKvA9WvdFP+IcZf65YIVRrVpsnYaWcchGyrpul9pS3oC4nX5cy34e9YbQuI+
	 AdDgAxLnK6zb9/rOglTqhhL1TXdh/dcChzgcG/eZW5u8VqLKRC1E54srghtaxfWZBCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794218992;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version:
	 X-Spamd-Result:X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:
	 X-Spam-Score:X-Spam-Level:X-Rspamd-Queue-Id;
	bh=pYc2D2gIh1SvVZ578/CJPxnyB11dD1eRwCTe2/iAXXc=;
	b=1fYAgd5L1q0KfEr7bF53dkVzLMxrYpiqZCCWuseTA1Z8kflcgTgBlEc3CoNZ2aHYu4uY
	 k/ts/HzuRLYkK6huFzBzXDIgUREGHDICQtNBSwHOkD+cPRAhFeFoYl12dCEO+JHiUqsyX
	 Et7xWL/gYl+aAbKcuLyDz6KWqL4sZmVuRtfx6iHp2wyE4wUBpJVAS6YXIfa+ZMwy9hTNM
	 rnqBznB+udAfj/mCbtH86yZCZw5PmSjRdJNM5ao6GuDZvMx9819ng0Ta5DD1tlHlSPxOO
	 Iimd7kIZ2JiRu5FDQDOwpyegq+vNfOnBES09NoPbodlP6H2dXI/yx01CfMcnjXxaD1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=gYBNGWyf;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=edp8xY+3;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4072F606A322;
	Mon,  9 Nov 2026 10:09:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4072F606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=gYBNGWyf;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=edp8xY+3
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E3C561F74A;
	Mon,  9 Nov 2026 10:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794218989; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pYc2D2gIh1SvVZ578/CJPxnyB11dD1eRwCTe2/iAXXc=;
	b=gYBNGWyfTs0hWQSJcZvCCWGIT82PJdPRLIFSOa4Ls6aTat15NIFNBvm7aP1lZhX0VSx05w
	BDUIp73FXsXCmcqHulJ6MttreAVhMvJN8yEOkLT2sm3j4kszd0bec03YJE/mdu70UMJKIU
	ste3rvGEGJSjPHM7dRXXVJw6IS6oLaU=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=edp8xY+3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794218988; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pYc2D2gIh1SvVZ578/CJPxnyB11dD1eRwCTe2/iAXXc=;
	b=edp8xY+3stIEeNp0JT5zOyuqkYQ/wMr8wz+uG/9X7jOChXu+SvyYut7VLFMcNl3lwcKrWt
	81M9H4tngtdn37T9rNeRzwTytTphV95QbLngWHjIn3HddnqsB3FD/zHNRQNWS19Pw3b9Gu
	72UnK6PvDXJy+eFhFjcYu+0vC5n3DxU=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2326C13302;
	Mon,  9 Nov 2026 10:09:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id juAiO+ub8WpZVQAAD6G6ig
	(envelope-from <mwilck@suse.com>); Mon, 09 Nov 2026 10:09:48 +0000
Message-ID: <f2b862d6106122031d3ad93ea3bd1a7964508de7.camel@suse.com>
Subject: Re: [PATCH] nvme-cli: nvmf-autoconnect: Consolidate vendor-specific
 NVMe-oF udev rules into a single file
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: John Garry <john.garry@linux.dev>, Nilay Shroff <nilay@linux.ibm.com>, 
 Guixin Liu <kanie@linux.alibaba.com>, Wayne Berthiaume
 <Wayne.Berthiaume@dell.com>, Vasuki Manikarnike	
 <vasuki.manikarnike@hpe.com>, Matthias Rudolph	
 <Matthias.Rudolph@hitachivantara.com>, Martin George <marting@netapp.com>, 
 NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>, Zou Ming
 <zouming.zouming@huawei.com>, Li Xiaokeng	 <lixiaokeng@huawei.com>, Randy
 Jennings <randyj@purestorage.com>, Jyoti Rani	 <jrani@purestorage.com>,
 Brian Bunker <brian@purestorage.com>, Uday Shankar	
 <ushankar@purestorage.com>, Chaitanya Kulkarni <kch@nvidia.com>, Sagi
 Grimberg	 <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>, Christoph
 Hellwig	 <hch@lst.de>, Marco Patalano <mpatalan@redhat.com>, "Ewan D.
 Milne"	 <emilne@redhat.com>, John Meneghini <jmeneghi@redhat.com>, Daniel
 Wagner	 <dwagner@suse.de>, Daniel Wagner <wagi@monom.org>, Hannes Reinecke
 <hare@suse.de>,  Benjamin Marzinski	 <bmarzins@redhat.com>, Christophe
 Varoqui <christophe.varoqui@opensvc.com>,  BLOCK-ML
 <linux-block@vger.kernel.org>, NVME-ML <linux-nvme@lists.infradead.org>,
 SCSI-ML	 <linux-scsi@vger.kernel.org>, DM_DEVEL-ML
 <dm-devel@lists.linux.dev>
Date: Mon, 09 Nov 2026 11:09:47 +0100
In-Reply-To: <20261109000834.513230-1-xose.vazquez@gmail.com>
References: <20261109000834.513230-1-xose.vazquez@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.62.1 
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Spamd-Result: default: False [-12.01 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[31];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RL8gn1pxsi5paq6ucqz1qzjyqe)];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -12.01
X-Spam-Level: 
X-Rspamd-Queue-Id: E3C561F74A

On Mon, 2026-11-09 at 01:08 +0100, Xose Vazquez Perez wrote:
> Replace individual vendor udev rules (HPE, NetApp, and VAST Data)
> with
> a unified 80-nvmf-storage_arrays.rules file, leaving the rules
> untouched.
>=20
> This shifts execution to the 80 range for a logical sequence after
> base
> discovery and autoconnect, while simplifying maintenance and
> packaging.
>=20
> Cc: John Garry <john.garry@linux.dev>
> Cc: Nilay Shroff <nilay@linux.ibm.com>
> Cc: Guixin Liu <kanie@linux.alibaba.com>
> Cc: Wayne Berthiaume <Wayne.Berthiaume@dell.com>
> Cc: Vasuki Manikarnike <vasuki.manikarnike@hpe.com>
> Cc: Matthias Rudolph <Matthias.Rudolph@hitachivantara.com>
> Cc: Martin George <marting@netapp.com>
> Cc: NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>
> Cc: Zou Ming <zouming.zouming@huawei.com>
> Cc: Li Xiaokeng <lixiaokeng@huawei.com>
> Cc: Randy Jennings <randyj@purestorage.com>
> Cc: Jyoti Rani <jrani@purestorage.com>
> Cc: Brian Bunker <brian@purestorage.com>
> Cc: Uday Shankar <ushankar@purestorage.com>
> Cc: Chaitanya Kulkarni <kch@nvidia.com>
> Cc: Sagi Grimberg <sagi@grimberg.me>
> Cc: Keith Busch <kbusch@kernel.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Marco Patalano <mpatalan@redhat.com>
> Cc: Ewan D. Milne <emilne@redhat.com>
> Cc: John Meneghini <jmeneghi@redhat.com>
> Cc: Daniel Wagner <dwagner@suse.de>
> Cc: Daniel Wagner <wagi@monom.org>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: BLOCK-ML <linux-block@vger.kernel.org>
> Cc: NVME-ML <linux-nvme@lists.infradead.org>
> Cc: SCSI-ML <linux-scsi@vger.kernel.org>
> Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>

Generally a good idea, but I think nvme-cli has a GitHub based
development workflow these days.

> ---
> BTW, there are two new I/O policies in development:
> https://lore.kernel.org/linux-nvme/20260815173502.1185929-1-nilay@linux.i=
bm.com/
> https://lore.kernel.org/linux-nvme/20261026111019.3724465-1-kanie@linux.a=
libaba.com/
> ---
> =C2=A0meson.build=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 |=C2=A0 4 +---
> =C2=A0nvme.spec.in=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=
=A0 4 +---
> =C2=A0.../udev-rules/71-nvmf-hpe.rules.in=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 5 ----
> =C2=A0.../udev-rules/71-nvmf-netapp.rules.in=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 |=C2=A0 6 -----
> =C2=A0.../udev-rules/71-nvmf-vastdata.rules.in=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 |=C2=A0 5 ----
> =C2=A0.../80-nvmf-storage_arrays.rules.in=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 23
> +++++++++++++++++++
> =C2=A06 files changed, 25 insertions(+), 22 deletions(-)
> =C2=A0delete mode 100644 nvmf-autoconnect/udev-rules/71-nvmf-hpe.rules.in
> =C2=A0delete mode 100644 nvmf-autoconnect/udev-rules/71-nvmf-
> netapp.rules.in
> =C2=A0delete mode 100644 nvmf-autoconnect/udev-rules/71-nvmf-
> vastdata.rules.in
> =C2=A0create mode 100644 nvmf-autoconnect/udev-rules/80-nvmf-
> storage_arrays.rules.in
>=20
> diff --git a/meson.build b/meson.build
> index 90356ad94..00e9ad1be 100644
> --- a/meson.build
> +++ b/meson.build
> @@ -894,9 +894,7 @@ if want_nvme
> =C2=A0=C2=A0=C2=A0=C2=A0 udev_files =3D {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 '65-persistent-net-nbft.=
rules': 'nvmf',
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 '70-nvmf-keys.rules':=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 'nvmf-autoconnect=
',
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 '71-nvmf-hpe.rules':=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 'nvmf',
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 '71-nvmf-netapp.rules':=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 'nvmf',
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 '71-nvmf-vastdata.rules':=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 'nvmf',
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 '80-nvmf-storage_arrays.rules=
': 'nvmf',
> =C2=A0=C2=A0=C2=A0=C2=A0 }
> =C2=A0=C2=A0=C2=A0=C2=A0 if want_nvmf_autoconnect
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 udev_files +=3D {'70-nvm=
f-autoconnect.rules': 'nvmf-
> autoconnect'}
> diff --git a/nvme.spec.in b/nvme.spec.in
> index 23d3d3268..a37c1a08d 100644
> --- a/nvme.spec.in
> +++ b/nvme.spec.in
> @@ -36,9 +36,7 @@ touch %{buildroot}@SYSCONFDIR@/nvme/hostid
> =C2=A0@UDEVRULESDIR@/65-persistent-net-nbft.rules
> =C2=A0@UDEVRULESDIR@/70-nvmf-autoconnect.rules
> =C2=A0@UDEVRULESDIR@/70-nvmf-keys.rules
> -@UDEVRULESDIR@/71-nvmf-hpe.rules
> -@UDEVRULESDIR@/71-nvmf-netapp.rules
> -@UDEVRULESDIR@/71-nvmf-vastdata.rules
> +@UDEVRULESDIR@/80-nvmf-storage_arrays.rules
> =C2=A0@DRACUTRULESDIR@/70-nvmf-autoconnect.conf
> =C2=A0@SYSTEMDDIR@/nvmf-connect@.service
> =C2=A0@SYSTEMDDIR@/nvmefc-boot-connections.service
> diff --git a/nvmf-autoconnect/udev-rules/71-nvmf-hpe.rules.in b/nvmf-
> autoconnect/udev-rules/71-nvmf-hpe.rules.in
> deleted file mode 100644
> index b050dd502..000000000
> --- a/nvmf-autoconnect/udev-rules/71-nvmf-hpe.rules.in
> +++ /dev/null
> @@ -1,5 +0,0 @@
> -# Set appropriate iopolicy for HPE Alletra Storage MP
> -ACTION=3D=3D"add", SUBSYSTEM=3D=3D"nvme-subsystem", ATTR{subsystype}=3D=
=3D"nvm",
> ATTR{model}=3D=3D"HPE Alletra", ATTR{iopolicy}=3D"round-robin"
> -
> -# Set ctrl_loss_tmo to -1 for HPE Alletra Storage MP NVMe/TCP
> -ACTION!=3D"remove", SUBSYSTEM=3D=3D"nvme", KERNEL=3D=3D"nvme*",
> ATTR{transport}=3D=3D"tcp", ATTR{model}=3D=3D"HPE Alletra",
> ATTR{ctrl_loss_tmo}=3D"-1"
> diff --git a/nvmf-autoconnect/udev-rules/71-nvmf-netapp.rules.in
> b/nvmf-autoconnect/udev-rules/71-nvmf-netapp.rules.in
> deleted file mode 100644
> index c76a3c434..000000000
> --- a/nvmf-autoconnect/udev-rules/71-nvmf-netapp.rules.in
> +++ /dev/null
> @@ -1,6 +0,0 @@
> -# Set appropriate iopolicy for NetApp ONTAP and NetApp E-Series
> -ACTION=3D=3D"add", SUBSYSTEM=3D=3D"nvme-subsystem", ATTR{subsystype}=3D=
=3D"nvm",
> ATTR{model}=3D=3D"NetApp ONTAP Controller", ATTR{iopolicy}=3D"queue-depth=
"
> -ACTION=3D=3D"add", SUBSYSTEM=3D=3D"nvme-subsystem", ATTR{subsystype}=3D=
=3D"nvm",
> ATTR{model}=3D=3D"NetApp E-Series", ATTR{iopolicy}=3D"round-robin"
> -
> -# Set ctrl_loss_tmo to -1 for NetApp ONTAP NVMe/TCP
> -ACTION!=3D"remove", SUBSYSTEM=3D=3D"nvme", KERNEL=3D=3D"nvme*",
> ATTR{transport}=3D=3D"tcp", ATTR{model}=3D=3D"NetApp ONTAP Controller",
> ATTR{ctrl_loss_tmo}=3D"-1"
> diff --git a/nvmf-autoconnect/udev-rules/71-nvmf-vastdata.rules.in
> b/nvmf-autoconnect/udev-rules/71-nvmf-vastdata.rules.in
> deleted file mode 100644
> index dcd6146d8..000000000
> --- a/nvmf-autoconnect/udev-rules/71-nvmf-vastdata.rules.in
> +++ /dev/null
> @@ -1,5 +0,0 @@
> -# Enable round-robin for Vast Data Block Subsystem
> -ACTION=3D=3D"add", SUBSYSTEM=3D=3D"nvme-subsystem", ATTR{subsystype}=3D=
=3D"nvm",
> ATTR{model}=3D=3D"VASTData", ATTR{iopolicy}=3D"round-robin"
> -
> -# Set ctrl_loss_tmo to -1 for Vast Data Block Controller
> -ACTION!=3D"remove", SUBSYSTEM=3D=3D"nvme", KERNEL=3D=3D"nvme*",
> ATTR{model}=3D=3D"VASTData", ATTR{ctrl_loss_tmo}=3D"-1"
> diff --git a/nvmf-autoconnect/udev-rules/80-nvmf-
> storage_arrays.rules.in b/nvmf-autoconnect/udev-rules/80-nvmf-
> storage_arrays.rules.in
> new file mode 100644
> index 000000000..1cd6c0c0b
> --- /dev/null
> +++ b/nvmf-autoconnect/udev-rules/80-nvmf-storage_arrays.rules.in
> @@ -0,0 +1,23 @@
> +##### Storage arrays
> +
> +#### Set iopolicy for NVMe-oF
> +### iopolicy: numa (default), round-robin (>=3D5.1), or queue-depth
> (>=3D6.11)
> +
> +## HPE
> +# Alletra 9000 / Alletra Storage MP / GreenLake Block Storage MP
> +ACTION=3D=3D"add", SUBSYSTEM=3D=3D"nvme-subsystem", ATTR{subsystype}=3D=
=3D"nvm",
> ATTR{model}=3D=3D"HPE Alletra", ATTR{iopolicy}=3D"round-robin"
> +ACTION!=3D"remove", SUBSYSTEM=3D=3D"nvme", KERNEL=3D=3D"nvme*",
> ATTR{transport}=3D=3D"tcp", ATTR{model}=3D=3D"HPE Alletra",
> ATTR{ctrl_loss_tmo}=3D"-1"

I'm not a fan of repeated lengthy match expressions in udev rules.
Can we improve the readability by using GOTOs and LABELS?

SUBSYSTEM!=3D"nvme*", GOTO=3D"nvmf_end"

ATTR{model}=3D=3D"HPE Alletra", GOTO=3D"Alletra"
ATTR{model}=3D=3D"NetApp ONTAP Controller", GOTO=3D"Ontap"
...
GOTO=3D"nvmf_end"

LABEL=3D"Alletra"
ACTION=3D=3D"add", SUBSYSTEM=3D=3D"nvme-subsystem", ATTR{subsystype}=3D=3D"=
nvm", \
    ATTR{iopolicy}=3D"queue-depth"
ACTION!=3D"remove", SUBSYSTEM=3D=3D"nvme", KERNEL=3D=3D"nvme*", \
    ATTR{transport}=3D=3D"tcp", ATTR{ctrl_loss_tmo}=3D"-1"
GOTO=3D"nvmf_end"

LABEL=3D"Ontap"
...
LABEL=3D"nvmf_end"


--=20
Dr. Martin Wilck <mwilck@suse.com>
SUSE Software Solutions Germany GmbH, Frankenstr. 146, 90461 N=C3=BCrnberg,
Germany
Gesch=C3=A4ftsf=C3=BChrer: Stefan Gaiser, Jochen Jaser, Abhinav Puri (HRB
36809,AG N=C3=BCrnberg)
