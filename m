Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [80.241.56.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E90F026B2DA;
	Sat, 18 Jul 2026 17:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784394194; cv=none; b=lyg3Dm8MgKXi8RGLeehNEMKVxWGIJXwMhiESnlMSf29htHvj/Zm7N/Q/FHYqd5nQkDOrVaULf0GU7H+kgi2dA3hBat9abTWqT2jVX0qlOuYzNeHVs1L6DuOXsBCLNiJzcZdSDdzUceSa5idQXyt4OcCW9JT2cB429M26VEJTIHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784394194; c=relaxed/simple;
	bh=Eo70NEU6KqAOrmNSdHxkeabKbAhSH9ivRl9nNEL052M=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=hpS/f4gTkPQGL98FXVdck+ibZ0QeeIPHGMocIzFYLcbTP7rDv3qoFuaKSeu4Gob+S/Ca0SGLG8P5n6ym3m95sGlmpGXJ09v0PD8pk8yBUwQP3LGcIo2tJL+VLlv+B8wUY0gFbu4dGt32fEhhnN98byLWMLM1wkQDFfONKOiqmrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org; spf=pass smtp.mailfrom=mailbox.org; dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b=aln+E3ea; dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b=P1KW0RuF; arc=none smtp.client-ip=80.241.56.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailbox.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="aln+E3ea";
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="P1KW0RuF"
Received: from smtp202.mailbox.org (smtp202.mailbox.org [10.196.197.202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA512)
	(No client certificate requested)
	by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4h2Y4l0wzyzMlGr;
	Sat, 18 Jul 2026 19:03:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1784394183;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Tzj3jkroeJ9qDDBuoFNN5o4ycSfZDKYPcOED/sOa+Lg=;
	b=aln+E3eaDYlrKxaSGm+3XSpYABwLi/lqLzy3Oq/jtOJc9K9Tps6sA48suz7viwG90Zg3Ni
	wqIG+itekNyrfXz+41zykPa4OlzUiIMP3Npkm6+tgr1j6s6Sxj803Pdj+bnrql4LPbTQxi
	j0b0WlVgCzzGEvrRwF6madkNIREjjEKRnzxRGRpu+OKHzuTSRdc2CnLuSKHZm+wo4nVHx6
	mLCmRhYh4q4Mww2gNWrDfXw4IsWJ3r3CW3CCZznwIOeywKFWB6Lks+KbtiNdGHrOkQtdS7
	uaedeQLxKm1WOhJQ4vatK2OWGOtpjlO74CcbJZkQJNAyNWwcvnWj9HYp1wgVow==
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1784394181;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Tzj3jkroeJ9qDDBuoFNN5o4ycSfZDKYPcOED/sOa+Lg=;
	b=P1KW0RuF0ntpYj4ZoBCfrMOhMBGzPbYCgUpbaeL1Wn4ib5OzTkiDIDo/p1j3QOU65c+DDl
	iGMhUQy3cTkjNWLuo8iKKT+ZDJE18EYX6SW4ZfihB/7x4xi4VC1spxl05O2kzzblBhd/dv
	kr9sOGx1z2CWIVp/sJMv9IwerysVsW4iinlWh5DvbHiAVPaGkBbHD2ykdKkt9aALllUIDw
	z7S08aSpusUPHeXVQs+zO4vrPaCLygYoUdJ/h6sMHdUvGQn9ruWFdq6gqC06sIV3tpyHsR
	aCIiCttc5Xl16k2AInJyP5fXCPElESzBdgxGOLmlwEhCov3FuZ3RRDBae0IUAA==
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 18 Jul 2026 19:02:51 +0200
Message-Id: <DK1UXXRGW737.2IVTYCHPRM9ET@mailbox.org>
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
Subject: Re: [PATCH v2] PCI: Move pci_dev->is_busmaster into priv_flags
From: "Maurice Hieronymus" <mhi@mailbox.org>
To: "Lukas Wunner" <lukas@wunner.de>, "Maurice Hieronymus" <mhi@mailbox.org>
References: <20260714-pci-dev-flags-v2-1-a1d7dc441cf3@mailbox.org>
 <alcSjoypegNolW48@wunner.de>
In-Reply-To: <alcSjoypegNolW48@wunner.de>
X-MBO-RS-ID: b5973a326c905eef11a
X-MBO-RS-META: ac7hnh6jjxdgumx33umeygikqfdzbxu6

On Wed Jul 15, 2026 at 6:54 AM CEST, Lukas Wunner wrote:

> pci_dev_assign_busmaster() should not have public visibility.
> Drivers should really use pci_set_master() / pci_clear_master()
> and nothing else.
>
> It seems Xen is the only one in the tree which needs this:
>
>> +++ b/drivers/xen/xen-pciback/pciback_ops.c
>> @@ -125,14 +125,14 @@ void xen_pcibk_reset_device(struct pci_dev *dev)
>>  		if (pci_is_enabled(dev))
>>  			pci_disable_device(dev);
>> =20
>> -		dev->is_busmaster =3D 0;
>> +		pci_dev_assign_busmaster(dev, false);
>>  	} else {
>>  		pci_read_config_word(dev, PCI_COMMAND, &cmd);
>>  		if (cmd & (PCI_COMMAND_INVALIDATE)) {
>>  			cmd &=3D ~(PCI_COMMAND_INVALIDATE);
>>  			pci_write_config_word(dev, PCI_COMMAND, cmd);
>> =20
>> -			dev->is_busmaster =3D 0;
>> +			pci_dev_assign_busmaster(dev, false);
>>  		}
>>  	}
>>  }
>
> Please change these direct assignments to pci_clear_master(),
> preferably in a separate patch to ease bisecting if anything
> breaks.
This conversion does not preserve behavior. The direct assignments
clear only the software flag, while pci_clear_master() also clears
PCI_COMMAND_MASTER in config space.

I am not an expert on xen devices. That's why I want to clarify first
that this does not break anything. Especially since commit
7681f31ec9cd ("xen/pciback: Don't disable PCI_COMMAND on PCI device
reset.") deliberately removed the PCI_COMMAND write right above the
first assignment, and pci_clear_master() would reintroduce a
PCI_COMMAND write there.

Best,

Maurice
