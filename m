Received: from fhigh-a4-smtp.messagingengine.com (fhigh-a4-smtp.messagingengine.com [103.168.172.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE7DF21D3CC;
	Wed,  3 Dec 2025 20:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764793935; cv=none; b=Ja0odaKYf6e7bFhOYSqZRDbzAdNValwcl336wqqjX0s11OY6/beE4BNSByO4EiUvizB1bPcaFWw0Q8dWyAknkB6zu9EH0CJI1ouwRfwiqbjwy3pfJr7B6GIQ14xicBeDr6QdR9wVqFdnmEMC+7kjxmHEQZPBIns+GPSjdl7thTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764793935; c=relaxed/simple;
	bh=YPK0k64dOD+3zdePS5bfGvkTs7O9+oH6iFliF5oYG1g=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=Hasbxk1jqJ9ZZy8n8zamxuEzE76Nf9YxSDLIIx6A4pnV4znRQJDeOx6oEPsZfZTBe1adgdE0lFpiKy7pCuhcggswQFB4qnt10MCJysTbQFU0s19Q1XI09uswvXbpJDcxm9HGbHw5w88QHl8w2dsQPfnvC1JNoiryYpjzBtIaAls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=YZIEfJ0j; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=GXVMH1ej; arc=none smtp.client-ip=103.168.172.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="YZIEfJ0j";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="GXVMH1ej"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 0921314000C1;
	Wed,  3 Dec 2025 15:32:06 -0500 (EST)
Received: from phl-imap-17 ([10.202.2.105])
  by phl-compute-04.internal (MEProxy); Wed, 03 Dec 2025 15:32:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1764793926;
	 x=1764880326; bh=EDURVxXoZBPQNYYglcnxiR31l3E2zyZboYhovndqQB4=; b=
	YZIEfJ0jFBvXkxHM82barl97u1LyBFpWOPBy51/mHlyai6cIGgLIT2nGVRKTb8PA
	uVAi4xeMA1H9/A9rv/3j+iYFllHrsyqXvq2jGnVFzDvVukELrTi1PJ478jRzRfBP
	TSsB+dGO6dVlsM1L1Zt+hBl1n7yyYo1p1iUlc1OhnVakb7dgBuL0S5zWZ50ogA9D
	Kbali2jW3akgTLY/MdpdfW6E/gg+iI17WlvNatIPuDElccR5xKebHN95l6omOz5g
	eEew/F+0VdMFuc/8dVrAio5YJgTMI/9vxAuoXscgEaM3SeaaNFHP92CeIRYt2Nk4
	Y41VqbaLi6aRKtlzRIBDrQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1764793926; x=
	1764880326; bh=EDURVxXoZBPQNYYglcnxiR31l3E2zyZboYhovndqQB4=; b=G
	XVMH1ejcaTMHcRghQB9XIRTJ5JJDGOjCbL3vyRmewIrBIYyc71EAf+hYK7kMfD68
	xMCHlD+JM7KSsrTjswEgu4xpjJH0kIAvMAKi6JOytbtjOwHaAk4LXRGd56NDjSQP
	AOQCvKp8eaFT7ZKXNbHIfhECjV9QlprbEldwDRWnwf03+/U8co7zXwHnZ0A+LiLu
	jk9OaC4+5DW/D+3/+hwxeQJGsSF98vh2U3P1Clw5IEO+LPGxHE4A9h3hp2p7OZ0t
	tE7cwhypvZ/yhE3b8r+QEkuOIiEuQaVwfcgc+v6h7oITOfTz0B1hef3d5CBSIVzu
	Ov4xYkI6deB4F/PkR09iQ==
X-ME-Sender: <xms:RZ4waeCqutWcs4Da-UvyeISHoV7MHs7KrN-R_bkToiMpo1IeFScH7g>
    <xme:RZ4waTXVDlgNpKWB264iuHRwVQCvAcDqdWdV7mcX9zVnMn2JMdcTHxxWy2L5uCuMX
    pHJZj8oKghcp602wyN2YQ0OWc8g6mbN5WOPr7BzO7CqFFVOSlFMe_qE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdefjeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceurghi
    lhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurh
    epofggfffhvfevkfgjfhfutgfgsehtqhertdertdejnecuhfhrohhmpedftehrnhguuceu
    vghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrthhtvghrnh
    epvdfhvdekueduveffffetgfdvveefvdelhedvvdegjedvfeehtdeggeevheefleejnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprghrnhguse
    grrhhnuggsrdguvgdpnhgspghrtghpthhtohepudefpdhmohguvgepshhmthhpohhuthdp
    rhgtphhtthhopegsvhgrnhgrshhstghhvgesrggtmhdrohhrghdprhgtphhtthhopehlkh
    hpsehinhhtvghlrdgtohhmpdhrtghpthhtohepsggvrghnhhhuohesihhokhhpphdruggv
    pdhrtghpthhtohepjhgvjhgssehlihhnuhigrdhisghmrdgtohhmpdhrtghpthhtoheplh
    hlvhhmsehlihhsthhsrdhlihhnuhigrdguvghvpdhrtghpthhtohepohgvqdhksghuihhl
    ugdqrghllheslhhishhtshdrlhhinhhugidruggvvhdprhgtphhtthhopegsvggrnhhhuh
    hosehmihgtrhhonhdrtghomhdprhgtphhtthhopehmrghrthhinhdrphgvthgvrhhsvghn
    sehorhgrtghlvgdrtghomhdprhgtphhtthhopegtrghnrdhguhhosehoshhsrdhquhgrlh
    gtohhmmhdrtghomh
X-ME-Proxy: <xmx:RZ4waeLw6DPpBTuCITfU2W7r57zH4mOCxu1F_2rBlX9Bp047RC5qMA>
    <xmx:RZ4waWQtrbH--7wJrp6aJWak047p6NT5taidkNmWmHmrNzXePV_vxQ>
    <xmx:RZ4waWJA6VQ-do_0GpDkDasa6WmmU8Urduv9iScCfu3IMEa5EMxozg>
    <xmx:RZ4waZ8VR7p0eNPz443PYKYsSs-sz-S5jAxsLe54ZChRQ0eDVPdTyA>
    <xmx:Rp4wafXsRp85s4E50cif_LlunKj1Fyq6TUrzoWnU0tH-lZOAFB_UlW7d>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 290D4C4006B; Wed,  3 Dec 2025 15:32:05 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: ALO74ngA5rV3
Date: Wed, 03 Dec 2025 21:31:44 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Bean Huo" <beanhuo@iokpp.de>, "kernel test robot" <lkp@intel.com>,
 avri.altman@sandisk.com, "Bart Van Assche" <bvanassche@acm.org>,
 "Alim Akhtar" <alim.akhtar@samsung.com>,
 "James E.J. Bottomley" <jejb@linux.ibm.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>, can.guo@oss.qualcomm.com,
 "Bean Huo" <beanhuo@micron.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <4eaccff9-a89d-4d0e-afbf-95e9996f9049@app.fastmail.com>
In-Reply-To: <fff872d022550536f05c181ad58577889af0b5ef.camel@iokpp.de>
References: <20251130151508.3076994-1-beanhuo@iokpp.de>
 <202512031316.SvDwnvhy-lkp@intel.com>
 <98ac8e0b-6027-4f6d-b5cf-b9ad9c856ecf@app.fastmail.com>
 <fff872d022550536f05c181ad58577889af0b5ef.camel@iokpp.de>
Subject: Re: [PATCH] scsi: ufs: core: Fix link error when CONFIG_RPMB=m
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 3, 2025, at 17:23, Bean Huo wrote:
> On Wed, 2025-12-03 at 15:39 +0100, Arnd Bergmann wrote:
>
> However, the robot reported redefinition errors, which suggests that t=
he
> header=E2=80=99s #else branch is being included while ufs-rpmb.c is al=
so being compiled.
>
> I=E2=80=99m wondering if I=E2=80=99m missing something about the robot=
=E2=80=99s build logic.
>

It took me a while as well, but I found the link to the patch that
was tested now, as this was the one that changed IS_ENABLED()
to IS_BUILTIN(), and that went wrong with CONFIG_RPMB=3Dm.

    Arnd
