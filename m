Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794997243;
	b=joOA5JwM4v1T1rvtWf7feNL/pURI1Vs+vCF3Z6KuK0gbG8/U/NS28Sj6hmX1QpT+0eZC
	 NdVLlJhh4vFmEemx8eMGKZVHaZ8wAFA1l6OVz/VmIGcjQERTfG4d2F/x/F/DbiQBkNZjG
	 x1LUp5L8I2816qa2im1OGmCh91vmQMLNeKonlnKwNYM04/VsIKJK5cuEMD2LSq30aMP2V
	 Uc8ofnuHhTWTUqOcScyQdgOMr2oyxSr8g6HQpxE8N7F/iirbHUPvYOyygqwv/4PgZmke1
	 hlRPJGVissOEzCR4AQbX50XoIAO4H9FIEgBHSLmISbe9ciYRZSA6LDg9Vv47/dRkOiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794997243;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=tZNnDpt+YU+5UxXTVqblLRg7xQoAnoVh2hamGHQd1bY=;
	b=LG+86luEu4sX/JgZfcRsqS4fPPDRRaj9fDG7vnxRvB6LIuXYyiLP8xhf/IJy5U/8w8Et
	 G6Llix74Ju/Yl2KABHyZyDCMDNjKOq29pO6i+jkpkSq8Zb4xFuAszQH8Lyg10VlHtvnQV
	 bB4ZSkcZdzpHHGaWseKyo4wdNjbdUWp54JAovADzAjXx+jl9DmljkemZXl++pOzIJNqZu
	 ZpFfEETOsQO9wLIl0I2cCrpF87M/+GuELaRd/IjkSbZxH5CCeCJTf6KPkoBZxACe/liQU
	 KUyYQ3bPCg3lH5C0kTtMR1QiDZl7oGlbIZQztMdXIY9B8qTwAa8KWEFBKIViVU4O8Qg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i9hwZJBo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76E99606A31C
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 10:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i9hwZJBo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0176F1F000C5;
	Wed, 18 Nov 2026 10:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794997243;
	bh=tZNnDpt+YU+5UxXTVqblLRg7xQoAnoVh2hamGHQd1bY=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=i9hwZJBoz4usr3zfRTsrlbneC1v6E/YJH7HpG8VUBfdSkiAZD/vgt8n3eLlaDSwLi
	 lgQRzK9VtE2YR89ShJUidE79qJi4+5Dz0IV8mDk6o7UzP/0tvULTUgeV9L+VKxGplW
	 wodM6euAdG4WGoCYwAmMlC1nu1tJnb4IK2IFmY7PIxrEDNK1ALTeQsYlRqmzOh/QHW
	 jxG9ZfTeQ3AtROxtBeAaoSrgBl70hIVwryvUORvAAIIsL4/PwlkU7xDoz/970UDdrf
	 fZrMXVWxDXDi0vXECvU296sOJgPoNfXkmrY/7Jw4sxbLHibegz9mvWVe70wcYTrv8S
	 +P1ygLaF8DrAg==
Message-ID: <sashiko-outbox-220677@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 13/37] scsi: mpt3sas: Validate max_data_size in
 MPT3EVENTREPORT ioctl
Reply-To: sashiko-reviews@lists.linux.dev
To: "Shivasharan S" <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
In-Reply-To: <1794995806-5835-14-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1794995806-5835-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1794995806-5835-14-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 10:20:42 +0000
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
- [Low] scsi: mpt3sas: missing Fixes trailer for _ctl_eventreport()
  underflow fix
--

commit f69a1ab648280769c7af16f9e89c971b1187d329
Author: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

> scsi: mpt3sas: Validate max_data_size in MPT3EVENTREPORT ioctl
>
> Reject a max_data_size smaller than the ioctl header size before
> using it in size arithmetic.
>
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>

[Severity: Low]
This fixes an unsigned underflow in _ctl_eventreport() present since the
driver was introduced.  Should this include:

  Fixes: f92363d12359 ("[SCSI] mpt3sas: add new driver supporting 12GB SAS")

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/1794995806-5835-1-g=
it-send-email-shivasharan.srikanteshwara@broadcom.com?part=3D13
