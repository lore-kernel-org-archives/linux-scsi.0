Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [80.241.56.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE37F44C649;
	Tue, 14 Jul 2026 19:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784057713; cv=none; b=ZUEmZVPDfGwDmvQZhNiXT5OUaQ0e2VyhiBFhbEBkOzFJ+8s84RMwcmKT8v3qJIiKp5HYmgYsu+otEWCH135ESDS/zzd2YSkitvdYpexlPG8hZCumXL+i0aV3s0Rwzi56kkykeJ4P5z8wZHZqkV7ZEtEHIhQHIOqcBmDrLn1+Fwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784057713; c=relaxed/simple;
	bh=k6uxr+UunWeCr0jqc3uJLy4BoPjB01Cn7PPlmFpF9bQ=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=WW1KUWvd8iyw700xcQvqrM8o582jn6iEup9HEsR9bupK/b5lrfRBFYDGGWBCAEVsU3Faw2oQ4i9Da4Z/QzW1bMCUDTKGNA5NVFkE/hTWHcAlMO6F9bkbuzxnJTuxsPhUw5Cx3Q8rh+8Xgor0Q+NrNXZR2yyknnhCEXkMdQo37MU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org; spf=pass smtp.mailfrom=mailbox.org; dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b=QuMdaAUm; dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b=lucqK6n8; arc=none smtp.client-ip=80.241.56.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailbox.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="QuMdaAUm";
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="lucqK6n8"
Received: from smtp202.mailbox.org (smtp202.mailbox.org [10.196.197.202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA512)
	(No client certificate requested)
	by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4h08f41257zMlGN;
	Tue, 14 Jul 2026 21:35:08 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1784057708;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k6uxr+UunWeCr0jqc3uJLy4BoPjB01Cn7PPlmFpF9bQ=;
	b=QuMdaAUmzBQNS2NVKgfWWqTT7THLOeBAvDNUU+v/k26L7jVqNPyWAgwjLisRzYB8kFltiB
	6yfXjdnENmfZ5qR/2jjl3ngZCY/pw65d20MopbgI2mh5qIfPCqk+B2TtKUBa6yqFa0HCdq
	rdLd7Ye6DQFAsRxd+QGVf83/A6ZsXhzF6IYA0whTbP+2yvMAFMGioq/QzzAnpnWD34/Oon
	R307E7+1eb/jGOJsTIJGw4MkpwmeJ+tYrNi+ICRyw91pvchm9pPdFspmF4KDV8m1TV3Cyo
	UX6blVrjnIOCmNcQHaAyv65u4kKOqmTypE7oLyDblYVoo4nqA57K7wKRFEtZBA==
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1784057706;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k6uxr+UunWeCr0jqc3uJLy4BoPjB01Cn7PPlmFpF9bQ=;
	b=lucqK6n8CkEfQ2vEfaJphbDANeuwE56/Z++FuFpnf7NvxqqxEM8R75w+XFselNZruYeSyJ
	2E++E1qBxf5JGQvP0er/p+FKtbJ6/Zfd0A62onSLk2QZNX6bfuQ68awTmvzoOf91NdKqKn
	rmPopbtKyRAosGiZ5enfDTyZ0VcU/TVUwgKFe4LM1OEx3QDhYqh2+LbSErwQWPbctj0n9S
	/M8PZ4YA1tvmLgQ4wNx3waZFxF2GfJY6NIiTj2Bo2gwmywYyKI6SUK1XHSZ6s8JSIfL+e7
	MNqas209UnyFOokBUeKxFf8e81pZvBIEV8Qlh1uZGkc5mDxdO7Jhqd7K1FxUPQ==
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 14 Jul 2026 21:34:56 +0200
Message-Id: <DJYJO745N6HZ.23EJ5DJ7I0BP5@mailbox.org>
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
Subject: Re: [PATCH 1/2] PCI: Replace pci_dev->is_busmaster with accessors
From: "Maurice Hieronymus" <mhi@mailbox.org>
To: "Lukas Wunner" <lukas@wunner.de>, "Maurice Hieronymus" <mhi@mailbox.org>
References: <20260711-pci-dev-flags-v1-0-2fcf2811138c@mailbox.org>
 <20260711-pci-dev-flags-v1-1-2fcf2811138c@mailbox.org>
 <alOkgrK7Fm6opB4r@wunner.de>
In-Reply-To: <alOkgrK7Fm6opB4r@wunner.de>
X-MBO-RS-ID: 26cc25a0ec5af51ece5
X-MBO-RS-META: nfsfy951dumk6mo6odtrggnyqgfwzm9r

On Sun Jul 12, 2026 at 4:28 PM CEST, Lukas Wunner wrote:

> We already have the priv_flags member in struct pci_dev,
> please use that instead of adding another one for the same purpose.
>
v2 moves the bit into priv_flags and exposes accessor functions
for those drivers which needs to access the flags.

Best,

Maurice
