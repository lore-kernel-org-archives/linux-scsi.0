Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793927713;
	b=iaqj7xYpyoPzAy2ZA/108vGpVz5dYC8YV0be4NIkpy21GMYiwU+VocqruR8ns38WZZ0d
	 aJv5W51KEBlfjxmTph0JpfSXRiCQEB85pvivW4sv+dfNu7YjHg2kMXyfNcECWH+8jwG7X
	 I0CHwHJAADSRp1kRKDhl2+rYSy0VcKXK58dhVq+it6eUS2FEstH4uiGNxdY9aAzUfiRts
	 G7QWGsEsCQ2cgFATVtHwDPUWi9BM2pkxt0699uODcdgKSAdS/2+F6l1hoTRULcFI6VNv1
	 HtpLj64pMdVExwanDCOsiHxQwsSzaAguwuxr4qjO6BzrEZX72jf0IvZR6apcZfdupzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793927713;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ECEeT0Vyc8Y8GDRj65+KO1GKP7eIYYGLAu/vRiKk+Cc=;
	b=1oi87LEDSoMYPoZL2FoA3QL4iFAH7NaWoalA10WDK7zhpLQ2V2culnqGZ/UV322Kuh/Y
	 I9vJcVccu4URhXUQMYBGgs3FcmZG4NsoEDSXoZOy+k6eW0AHP175NMn1UO3gm3K3xaMx2
	 AXzaOrWxE6hzXYo1S5O6UbkKfOiF8Cfw3JKxchG1HznX+px6RzIFn0hCypL2lrZ+M8BS2
	 mL1o+QiXkXAiuGr4Jm3h3B2trqF/cBQm5QSoQtp1rmAxRfRsz23DoQ44s30ZhqgvT6ejz
	 AIxHTi/Dn1AXWwsqrTItPNRYjACIMksN2r1kZP4lhz9nu/OhpJyXGQ9IYTjC880gNhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T4DMbMr8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1012606A31B
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2026 01:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T4DMbMr8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C1BA1F0089F;
	Fri,  6 Nov 2026 01:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793927712;
	bh=ECEeT0Vyc8Y8GDRj65+KO1GKP7eIYYGLAu/vRiKk+Cc=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=T4DMbMr8rMAE/KBVLcHaX90+Ta9dw4GChmy7pAe4cf+ntdg7cUnu4igSxvV9VKceb
	 NQv5jnKAb6j13qdaf9tfJjByThEtcl3pE6TS0k2v+yMfd6J/O2QRoaeYQGEnCEUaJy
	 5C8kbNsbh25yz7oSbAr+bQyfFJTPJ4K9x4RKbTgNnaozeskljB0DzDNanO92cbzR6F
	 rLdFS5Kg/1a0fX6n6dm8RAuMTPbt7hP2sj7CXptnKMf/J69mG49An2qNG+T0rPCW2p
	 6PtiE10l+JpFT3QJS60Z27lkQlpxsEWK/t9e2n9wwuiMnl9nyd0mDiroiiNQnnbWbS
	 SThCTSFGAxuGA==
Message-ID: <sashiko-outbox-200494@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 08/37] scsi: mpt3sas: Validate firmware/user supplied
 device handles against MaxDevHandle
Reply-To: sashiko-reviews@lists.linux.dev
To: "Shivasharan S" <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
In-Reply-To: <1793925772-1303-9-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1793925772-1303-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1793925772-1303-9-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 01:15:11 +0000
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
- [High] scsi: mpt3sas: infinite retry loop when _scsih_add_device() return=
s -1
--

commit 366cf2a2a69371d1bf988949aa77181dfdc2bddd
Author: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

scsi: mpt3sas: Validate firmware/user supplied device handles against MaxDe=
vHandle

This commit validates firmware-supplied and ioctl-supplied device handles
against ioc->facts.MaxDevHandle across event handling, device discovery,
post-reset scanning, and task management/control completion paths. It also
changes the passthrough handle boundary check in _ctl_do_mpt_command() from
> to >=3D.

> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/=
mpt3sas_scsih.c
> index 8dcbe60db542e..a697200844078 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c

[ ... ]

> @@ -8399,6 +8418,12 @@ _scsih_add_device(struct MPT3SAS_ADAPTER *ioc, u16=
 handle, u8 retry_count,
>  	u8 connector_name[5];
>  	u8 port_id;
> =20
> +	if (handle >=3D ioc->facts.MaxDevHandle) {
> +		ioc_err(ioc, "handle(0x%04x) out of bounds in %s\n",
> +			handle, __func__);
> +		return -1;
> +	}

[Severity: High]
Does returning -1 here cause an infinite retry loop in callers that treat
any non-zero return from _scsih_add_device() as a retryable condition?

In _scsih_scan_for_devices_after_reset(), the SAS end-device scan loop
reads handle =3D le16_to_cpu(sas_device_pg0.DevHandle) without checking it
against ioc->facts.MaxDevHandle before calling _scsih_add_device():

	retry_count =3D 0;
	/* This will retry adding the end device.
	 * _scsih_add_device() will decide on retries and
	 * return "1" when it should be retried
	 */
	while (_scsih_add_device(ioc, handle, retry_count++,
	    0)) {
		ssleep(1);
	}

Similarly, _scsih_sas_topology_change_event() checks the return value when
handling MPI2_EVENT_SAS_TOPO_RC_TARG_ADDED:

	rc =3D _scsih_add_device(ioc, handle,
	    fw_event->retries[i], 0);
	if (rc) {/* retry due to busy device */
		fw_event->retries[i]++;
		requeue_event =3D 1;
	} else {/* mark entry vacant */
		event_data->PHY[i].PhyStatus |=3D
	    MPI2_EVENT_SAS_TOPO_PHYSTATUS_VACANT;
	}

Because _scsih_add_device() returns -1 at the start of the function before
retry_count is checked in _scsih_wait_for_target_to_become_ready(),
wouldn't an out-of-bounds handle cause _scsih_scan_for_devices_after_reset()
to loop forever holding ioc->reset_in_progress_mutex, and cause
_scsih_sas_topology_change_event() to requeue fw_event indefinitely?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/1793925772-1303-1-g=
it-send-email-shivasharan.srikanteshwara@broadcom.com?part=3D8
