Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [80.241.56.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38CC344C648;
	Tue, 14 Jul 2026 19:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784057823; cv=none; b=QmsuJ+Q+KCVCm6kOpF+9EiCLFY8jVTZA8F9ci8BUy+FEpcsutb8T74QPjq4zbrKg0s8gXpxkJdnPa6uBjwnPswIjjoLwe94K0N1OEdlz9+JnIGpM7r6VeoU4+WUxRFCebYyFKGW+NktUu0HxDuVR4NApMp33OS0Jr5lQMLIEzZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784057823; c=relaxed/simple;
	bh=qHaXUl200pL6nJZtzXnzHu1oFgry5MeFbAsDAc/Iang=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=sSMbVLDJcYhG36oXePVjkrkXwYC7SP1r7/8jch4R5alVWJkc2zKGHYYDZFVXTc5ilz4m5SWbP/EmT7E9Z8vO+M0hkUP/7zcQ6UGuxgka2uSgQ3O4GfiSO3Td0oCC847KJ0ovPgdEJGsRo4cJ2Pp9du1S6TYCk2llyVxcZP5iIMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org; spf=pass smtp.mailfrom=mailbox.org; dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b=e7S0Tu+D; dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b=xvjOuN1v; arc=none smtp.client-ip=80.241.56.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailbox.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="e7S0Tu+D";
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="xvjOuN1v"
Received: from smtp102.mailbox.org (smtp102.mailbox.org [IPv6:2001:67c:2050:b231:465::102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA512)
	(No client certificate requested)
	by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4h08h95yhsz8v36;
	Tue, 14 Jul 2026 21:36:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1784057817;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w0Wi1q4BS9lRkpK3qWatwz/kytotQz+59Wf8+u9AiPE=;
	b=e7S0Tu+DVytj4usCrWgwVM68Xix/RP4xbXYX03+zsC3FQigbyTnQzw8qzY94nhifaX4Iuf
	eTJxwzcBYzWiReEMzVWOzbbejPqqfWUlEKH9UyDi6UlY7AOIXmjOR//HCXwNYLsB/WeZ5E
	LUY1FqhjRM4b7sEp/HgY+G3t7oe3B+z9iCdnGIkZc8SupiJuRc+xpK0dDWDpZIQ5uHAu/f
	Bi4wqQ/fsdCx1jNzzWW9rwO3KVhLi9zK6DQ81SVGDdwYoy7k6EjZxcxvBzZBV02cE+5Jdq
	ZXyTkriURJnhccpDFLAkNoNOEGTZWstGYAJ+XK3jO256RSCzojN0YdoAQmCuIQ==
Authentication-Results: outgoing_mbo_mout;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=xvjOuN1v;
	spf=pass (outgoing_mbo_mout: domain of mhi@mailbox.org designates 2001:67c:2050:b231:465::102 as permitted sender) smtp.mailfrom=mhi@mailbox.org
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1784057815;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w0Wi1q4BS9lRkpK3qWatwz/kytotQz+59Wf8+u9AiPE=;
	b=xvjOuN1vzLKjZ26Tmn+S2qLO3u+8OwUIfuWAayCB2SKrbAhd1wB9h6niBpWpt0p5qmeWiR
	vBkk+2rOsDleEmE2O4vyR7KZv28n97ejyHwOTDqthsf5NfADAm4cc3VoauGrf/FEhJbrQb
	iJuRoAo+jBdNFmU1JdZewC6s9eA49cae+qlTW/trKz4oJsnlNtegNHVhaL+uUVYnbCXucI
	crFz4AoN/ZQwF7uTrzBMpeVHtwJMmi5Pb7AFvhw3OK7kongiigRedeFwapJvVXHXYgol9x
	VzFwDGyI4QIl2yFfPINCRjhtQFvOYJLMaVFRGRMU4Z2lWq9fFLWF5m4T4vYhfQ==
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 14 Jul 2026 21:36:44 +0200
Message-Id: <DJYJPKVVNEYV.1VCK4XOL7XLXE@mailbox.org>
Cc: "Edward Cree" <ecree.xilinx@gmail.com>, "Andrew Lunn"
 <andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, "Eric
 Dumazet" <edumazet@google.com>, "Jakub Kicinski" <kuba@kernel.org>, "Paolo
 Abeni" <pabeni@redhat.com>, "Bjorn Helgaas" <bhelgaas@google.com>, "Justin
 Tee" <justin.tee@broadcom.com>, "Paul Ely" <paul.ely@broadcom.com>, "James
 E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, "Martin K.
 Petersen" <martin.petersen@oracle.com>, "Juergen Gross" <jgross@suse.com>,
 "Stefano Stabellini" <sstabellini@kernel.org>, "Oleksandr Tyshchenko"
 <oleksandr_tyshchenko@epam.com>, "Miguel Ojeda" <ojeda@kernel.org>, "Boqun
 Feng" <boqun@kernel.org>, "Gary Guo" <gary@garyguo.net>,
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, "Benno Lossin"
 <lossin@kernel.org>, "Andreas Hindborg" <a.hindborg@kernel.org>, "Alice
 Ryhl" <aliceryhl@google.com>, "Trevor Gross" <tmgross@umich.edu>, "Daniel
 Almeida" <daniel.almeida@collabora.com>, "Tamir Duberstein"
 <tamird@kernel.org>, "Alexandre Courbot" <acourbot@nvidia.com>,
 =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>, "Borislav Petkov"
 <bp@alien8.de>, "Tony Luck" <tony.luck@intel.com>, "Danilo Krummrich"
 <dakr@kernel.org>, <rust-for-linux@vger.kernel.org>,
 <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>,
 <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
 <linux-scsi@vger.kernel.org>, <xen-devel@lists.xenproject.org>,
 <linux-edac@vger.kernel.org>
Subject: Re: [PATCH 2/2] PCI: Replace pci_dev->broken_parity_status with
 accessors
From: "Maurice Hieronymus" <mhi@mailbox.org>
To: "Lukas Wunner" <lukas@wunner.de>, "Maurice Hieronymus" <mhi@mailbox.org>
References: <20260711-pci-dev-flags-v1-0-2fcf2811138c@mailbox.org>
 <20260711-pci-dev-flags-v1-2-2fcf2811138c@mailbox.org>
 <alOq4rsjATipBjY9@wunner.de>
In-Reply-To: <alOq4rsjATipBjY9@wunner.de>
X-MBO-RS-ID: 05fc47b8a807a8d7f87
X-MBO-RS-META: jwkwhigke4zsupccfdb75c4p5d75mnzy
X-Rspamd-Queue-Id: 4h08h95yhsz8v36

On Sun Jul 12, 2026 at 4:55 PM CEST, Lukas Wunner wrote:
>
> For static bits in struct pci_dev, i.e. ones that are mostly read
> and almost never written, and in particular ones that are only
> written on device enumeration, it's perfectly fine and more convenient
> to keep them as bitfields.  broken_parity_status seems to fit that bill.
>
Its only writer is broken_parity_status_store(), so it is written from
sysfs at arbitrary times rather than on enumeration. But I agree the
exposure is small; apart from the sysfs attribute itself, EDAC is the
only reader.

> For other bits which are modified more frequently, move them to the exist=
ing
> priv_flags member if you believe they can be updated concurrently.
> I'm not sure is_busmaster fits that bill, it isn't updated that often.
>
The motivation is not update frequency. The planned Rust device
enabling rework [1] wants a guard object whose drop calls
pci_disable_device(), which may then run concurrently with
pci_set_master(). Moving is_busmaster out of the bitfield stops those
paths from writing to the word shared with the other bits.

> Quite honestly I'm wondering if there is anything to fix here.
> Yes I get it, userspace may interfere with adjacent bits.
> But broken_parity_status is only used for certain broken devices
> on EDAC-capable platforms.  That's a fringe use case.
> Is it really worth refactoring this?
>
I dropped this patch in v2 and moved only is_busmaster, into
priv_flags as you suggested.

> Perhaps we can deprecate the sysfs attribute in favor of using quirks
> for broken devices?
>
That sounds like the better long term fix to me, but I would leave it
to a separate discussion.

[1] https://lore.kernel.org/rust-for-linux/DJOEYVBS17MJ.1YD3TNGQBWHNK@kerne=
l.org/

Best,

Maurice
