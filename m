Received: from fout-b4-smtp.messagingengine.com (fout-b4-smtp.messagingengine.com [202.12.124.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0FCF2627EA;
	Tue, 25 Feb 2025 09:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740477398; cv=none; b=qyEdsjkouSTZrn7NlDIONQluK6wGIYNd3dwg74XawO/4QrDLXmwnIXd4d/M8w+kzyml3YiIFcjeQi0JB7yNlFe0tv7KLsJiOJTRanA9bUBL+HsHgQVueR4EQ17L5PNxvjq7zEN2aM2iHtAe66UZdgjv58fL7d5sEU1tGRdufqmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740477398; c=relaxed/simple;
	bh=68ttojluSMJekMUqzzeXMubHGmH1ha6jxqsSp2QWAqE=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=OShxQ61iMDjk/qv0xIJQUGAGLnnWiMDgHJRmRdQnxKoVkOHHmL4A7+sLKM0xBEZ4JJIMNic+LfS2N6AMhH7lH18NJ2qkHw9IXgX7VgicrLQJCGJtJamhUjGMXfg5n/aHkivGrjLDPrXT5cf/X2R7C9ZrGM2rV0NnTKP287wJ3TA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=Xynfsgmh; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=8fKO8/n+; arc=none smtp.client-ip=202.12.124.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="Xynfsgmh";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="8fKO8/n+"
Received: from phl-compute-11.internal (phl-compute-11.phl.internal [10.202.2.51])
	by mailfout.stl.internal (Postfix) with ESMTP id 610021140125;
	Tue, 25 Feb 2025 04:56:34 -0500 (EST)
Received: from phl-imap-11 ([10.202.2.101])
  by phl-compute-11.internal (MEProxy); Tue, 25 Feb 2025 04:56:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1740477394;
	 x=1740563794; bh=oPS10ASssnGnkXuycAVP3rVR9hdopqe8E2btWHUYBvI=; b=
	Xynfsgmhj9uUqd4NEt4nCuSuIY6Ve0lHZTUkhm8fXh+sdM3SA+sPyD72rT5NiKNd
	wamW7ZtRuCrrK158qatOHu2RsNpgnL1gKon1ixPaKUh5uaQvUeBH6ntlbrwuV6Yf
	JknmW9pYeIylncCxFjW7egRAvGmwspWncpfCmVbmVpJwLTG5WQSpu8mPX8DlBBKj
	hD9cunEVM5heEFO5d0/RXjgnKjcDfS2claqG8yhS9xedXhLmJEHEEttXp1wKmdx7
	YhvN3WDnDc5hXO8Emt2gpPb6VTYAv0X/UqO3ZgyvE+3VAcpjc2uR5IGUr1WUb635
	mDcbkhZZiD2PLUr9IWULMQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1740477394; x=
	1740563794; bh=oPS10ASssnGnkXuycAVP3rVR9hdopqe8E2btWHUYBvI=; b=8
	fKO8/n+8QriWyC9tTYRjDKuFxzh4LKD7yTqPLsKVuvrb5s6RZPzEJrcL5Yvr+8C+
	8Z3TiQlIp/Nx0ivoEepeQraUi7KhGpKIQHvKh93Ua9KAgVcYcZPz5SQE0fIHSnid
	tGsug2KG4IKoJaLTReLMJkLPCiUG0r4iBWzJUCLg70gguOldc3U+K0FQ2WCYL9IS
	b6oUUJqM323FsXS4mu/4kXoikhFWscD6I349aYaR5OgM+4ZdWNmbTWZTgIRR2+j5
	ys65Bzce7ow1MPZxDfAvddTja8XSbgmRF7s2k84Uv8Zsm7jSGmvl0nGZrIOOPC/e
	MqsIWPowR/oruimg27yQg==
X-ME-Sender: <xms:0ZO9Z9lhcJ5kxi-U9S8Gw0UKD2LBNZ1A-vQZsW0zR0MVEP5hTQ9jUA>
    <xme:0ZO9Z427xBeECGhNdSHSiyPXDHFyEDg-CH1-KFcTXkG_gUSOnolJ-2jbSOnG1iyNo
    UzYr13OycgWUyQZTI0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefvddrtddtgdekudeflecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdp
    uffrtefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivg
    hnthhsucdlqddutddtmdenucfjughrpefoggffhffvvefkjghfufgtgfesthhqredtredt
    jeenucfhrhhomhepfdetrhhnugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusg
    druggvqeenucggtffrrghtthgvrhhnpedvhfdvkeeuudevfffftefgvdevfedvleehvddv
    geejvdefhedtgeegveehfeeljeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpegrrhhnugesrghrnhgusgdruggvpdhnsggprhgtphhtthhopeel
    pdhmohguvgepshhmthhpohhuthdprhgtphhtthhopegsvhgrnhgrshhstghhvgesrggtmh
    drohhrghdprhgtphhtthhopehjrghmvghsrdgsohhtthhomhhlvgihsehhrghnshgvnhhp
    rghrthhnvghrshhhihhprdgtohhmpdhrtghpthhtoheprghrnhgusehkvghrnhgvlhdroh
    hrghdprhgtphhtthhopehkrghirdhmrghkihhsrghrrgeskhholhhumhgsuhhsrdhfihdp
    rhgtphhtthhopehjohhhnhdrghdrghgrrhhrhiesohhrrggtlhgvrdgtohhmpdhrtghpth
    htohepmhgrrhhtihhnrdhpvghtvghrshgvnhesohhrrggtlhgvrdgtohhmpdhrtghpthht
    ohepjhhmvghnvghghhhisehrvgguhhgrthdrtghomhdprhgtphhtthhopehlihhnuhigqd
    hkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhig
    qdhstghsihesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:0ZO9ZzrhoAILGRRQXWwXnjTJD1-2dcgXLFtkhe61uq5nhFYGsKBGAA>
    <xmx:0ZO9Z9ltNdtlg3864A1ByVS9tmmJD-h3AmFH_xVoyYFwrQwgeshsXg>
    <xmx:0ZO9Z71_wASsLvpN4WMMgoCjgEKz0wGEw9T3MmRSPBoXckzceaKNqw>
    <xmx:0ZO9Z8vN3CGoFscH9nFL-JJ5lVqxkLdzTEFKgn3YnxDVeIV7skyshw>
    <xmx:0pO9Z0KMkvJwlR_nq4DqTvIw6FEpuLQ4dzdZOilmf6lg2zboI7-XTkmS>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 9289A2220072; Tue, 25 Feb 2025 04:56:33 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 25 Feb 2025 10:55:31 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: 
 =?UTF-8?Q?=22Kai_M=C3=A4kisara_=28Kolumbus=29=22?= <kai.makisara@kolumbus.fi>,
 "Arnd Bergmann" <arnd@kernel.org>
Cc: "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 "John Meneghini" <jmeneghi@redhat.com>,
 "Bart Van Assche" <bvanassche@acm.org>,
 "John Garry" <john.g.garry@oracle.com>, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-Id: <035217f4-07fc-4b09-81e6-522843ea26cc@app.fastmail.com>
In-Reply-To: <367BED6D-3187-473C-BBF4-EB71A0E1677A@kolumbus.fi>
References: <20250225085644.456498-1-arnd@kernel.org>
 <367BED6D-3187-473C-BBF4-EB71A0E1677A@kolumbus.fi>
Subject: Re: [PATCH] scsi: scsi_debug: fix uninitialized variable use
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 25, 2025, at 10:43, "Kai M=C3=A4kisara (Kolumbus)" wrote:
>> On 25. Feb 2025, at 10.56, Arnd Bergmann <arnd@kernel.org> wrote:
>>=20
>> Fixes: e7795366c41d ("scsi: scsi_debug: Add READ BLOCK LIMITS and mod=
ify LOAD for tapes")
>
> The bug was actually in 568354b24c7d "scsi: scsi_debug: Add compressio=
n=20
> mode page for tapes"

Ah indeed, my mistake. At least I got the right author.

>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>
> Acked-by: Kai M=C3=A4kisara <kai.makisara@kolumbus.fi=20
> <mailto:kai.makisara@kolumbus.fi>>

Thanks!

I'll resend with the correct fixes tag

      Arnd
