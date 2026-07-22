Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05DAA33B951;
	Wed, 22 Jul 2026 14:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784728828; cv=none; b=fK0RGH4+uamEN0faduAfCJDgq79HPaT8msIN5AqU4Zdb451bEU+jkaVV6Qmcl509d3m58hwnVGlGAavhU7KjmD8drkuezQifHPjZUYDsyn15OwC7IEQe4i36/TvVyJpsewaBHSqX4dHF6O8sPgb99MzyRLR5SshNg76lSNYansY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784728828; c=relaxed/simple;
	bh=bjdtU0qURpQUixi6R0Jjk5sdGK9ApGV+3+mAC//psFA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GNQ7wfq8gBe6JX7JSk4Ab9WHZZzzgpgUVCcoQjiXyh6d0TzKWH6kxTjgEbbCa0SxK1pFTlx7EgOohjAe4G2ZFwCHso6pm2sMPCasGOM2lkUvM46DQhpcvwQO2qlM/i418kxNIMFb4CXeyxSoenBhMEp06TlJFS6affBBzbE2fLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=uq4zRlf/; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="uq4zRlf/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=HpDOG/u1a0nOd4GgQOk7svGj4fcu1XMWhxK7aAAj/tk=;
	t=1784728827; x=1785938427; b=uq4zRlf/6prQ7h9LgXvyUslxQXaD4aTIzghcEjwobvsbfbC
	Q9MBTpWFz1wS6Ca6k+HWLsy6TBHHD9pNvdLSa+raaD+q1a53MFAcJU6PP2U6LWJB3+O+v5vR/0jSe
	Xe05ZxYiHVBGapm1oaOBLaJhlV3SywvSS4XEO3LyPyQn5pNHZU4qxR7YiogO5+K0mGcon2DetB5H2
	m+0qOnTWcHCdE1KFiVK633pVDt86hNOunhcLMP8dpmBWEV5WrjZuSchSOGIHczJFjjEWaWQIunYbw
	QbjlkZUwDogbGuwU+90PIiaM4lkvLp0pCtmNdwFsD87bkhxu3oPgEG/iqshyj2eQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wmXUe-00000004nVi-2mh5;
	Wed, 22 Jul 2026 16:00:16 +0200
Message-ID: <e30c8cebe5d0a6cfada18c633be0125774ef0c7f.camel@sipsolutions.net>
Subject: Re: How to fix problems with the sashiko review model
From: Johannes Berg <johannes@sipsolutions.net>
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Greg KH
	 <gregkh@linuxfoundation.org>
Cc: sashiko-reviews@lists.linux.dev, Chris Mason <clm@fb.com>, Roman
 Gushchin	 <roman.gushchin@linux.dev>, linux-scsi@vger.kernel.org,
 ksummit@lists.linux.dev
Date: Wed, 22 Jul 2026 16:00:15 +0200
In-Reply-To: <e8f7c3614c15a86b335576074fec1768d95f3df4.camel@HansenPartnership.com>
References: <20260722041257.1557-1-pengpeng@iscas.ac.cn>
		 <20260722042744.5C1B01F000E9@smtp.kernel.org>
		 <dcadf40a07a616de931c484bbe68f4b3f1f83b80.camel@HansenPartnership.com>
		 <2026072224-moisture-gonad-409f@gregkh>
	 <e8f7c3614c15a86b335576074fec1768d95f3df4.camel@HansenPartnership.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Wed, 2026-07-22 at 09:42 -0400, James Bottomley wrote:
>=20
> Well, I noted that in my reply above.  The way I was thinking of
> implementing it was to add a general instruction file for drivers which
> would make hardware trusted for pretty much everything and then
> instruct the AI to consult driver specific files for overrides to this
> so we could add the additional threat checks to usb.md and virt.md

I guess it's a question which way around it should be - but I'll note
that generally for wifi customers tend to not trust the "hardware"
because it's mostly firmware, is generally buggy and can be attacked
over the air too...

Personally (with that background) I'd tend to lean towards saying the
high-performance stuff that does want/need to trust the device should
opt out, it's harder to get that wrong. If we generally opt out as you
describe and then forgot to include something, we might have issues.

johannes
