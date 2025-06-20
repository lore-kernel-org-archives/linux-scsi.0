Received: from fout-b5-smtp.messagingengine.com (fout-b5-smtp.messagingengine.com [202.12.124.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7EC51DE3C3;
	Fri, 20 Jun 2025 14:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750430748; cv=none; b=BFYQtJH+NQ2DsaNBps9vw9rafsWpr7T3WaM/Itejnx30E44uY//4EPk3KXc0d74wLdCoERmauXMOON3/Fq84ktpDTdgiu98gHhmZ78WTOx/bDbhY2Ggzp0N1ejPqrWWJinp6iBl+4dkoAL9UaafIeMVnDAqTZgGJMgPREy37gvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750430748; c=relaxed/simple;
	bh=KM+faQe66poOoKhy4vqdIItp4UFmjlUVugv4gcwOTbM=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=mrU6yHsTo3A2wowu6Y3zsORnZWIQLEfjDXA3Rw225BMtUWIRk17TCPD3m43banrsICCGVKBgqrHP4lZj7el8u3mvNx3HPZse1KU4rTFoJ0EcbocgpiJz65MKM4HO+J/1Zob8seCR3ziXe30jkXEvyvPiwB2uQiC1N1xMDa4hhy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=BjJ7RGrE; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=nd1u1str; arc=none smtp.client-ip=202.12.124.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="BjJ7RGrE";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="nd1u1str"
Received: from phl-compute-05.internal (phl-compute-05.phl.internal [10.202.2.45])
	by mailfout.stl.internal (Postfix) with ESMTP id 93861114022D;
	Fri, 20 Jun 2025 10:45:45 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-05.internal (MEProxy); Fri, 20 Jun 2025 10:45:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1750430745;
	 x=1750517145; bh=W+jO+12kpWz9YoaOeriqxBhzNpXk/foSVJANLYzthxg=; b=
	BjJ7RGrEM6Qydz4rEDZXWHfXa6Dwuj/5gRfOI8/T85sFB0ArYmRHbJumSg28eQea
	xk4Q3SpJiP+9TJdPKSAqDmZL1xuTTVtR+Q1J50z3tAkRwxHHdG4Ba0KDJJqXCnsy
	QBGJFiHK4jFPrHOY5qu1SXUfv8B1gOBXXcmRhIJc6XlO5sgt8PIzeIQUAnre/WQm
	7sTr6dy7v6BOBY7sgZjm9dx2aqstfMYJpi5Ui9jWdzQdYzKPVY8J+WQe6mqDq40Q
	IvlbkQArcKEpO35+t/XLt+VdU4S9Su1VbcfD/v/Wipf6jimXV0/NZMpQXLwqUUeT
	FgXiFPtsi2fjdoa/TAmD3A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1750430745; x=
	1750517145; bh=W+jO+12kpWz9YoaOeriqxBhzNpXk/foSVJANLYzthxg=; b=n
	d1u1strG74xFvfC8PAQjeMAXE0CTAwtg1ywokUhfYTnXUK/Pbo45M92FxE5ZD8G1
	QCb4QIDz8b88V4xs61t6w7NwLI7rF4TqnRo1rYVpg//yXmHInKncQFKefvjVtwRr
	T674uhXap5Q1/XWZyP3hNiRNKgCj0QKPMmx+zXXkv/JZTgOpBCiwj0BXMd0KDU/V
	Cbu7lQA71zJwCWR8uAA/5qYGO0QVlhO8PirRmaq931jQ5vDvoBvqbaHUxd7v7mgS
	IxWHvCWSE96bHhTV+ivUFylICIHqhiUfIE4hpn3ZtNYAv7GGNOnFPM7uxpVu662r
	rX0mUoCw0//h3OQH/dftw==
X-ME-Sender: <xms:GHRVaPQynn1jfNjOQFY2l9KwaPihpCHTPC2yC1qjYwfz0L9gl3eiIg>
    <xme:GHRVaAwGCXdKJ8NAm3elAfxti9sA8FIlAoxKbhN3rGBBOujvdMeTarIuJNzqV0G-3
    fFVHbq2Q2c8iXxmK3s>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtddvgdekieekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceurghi
    lhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurh
    epofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrnhguuceu
    vghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrthhtvghrnh
    ephfdthfdvtdefhedukeetgefggffhjeeggeetfefggfevudegudevledvkefhvdeinecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprghrnhguse
    grrhhnuggsrdguvgdpnhgspghrtghpthhtohepuddupdhmohguvgepshhmthhpohhuthdp
    rhgtphhtthhopehjrghmvghsrdgsohhtthhomhhlvgihsehhrghnshgvnhhprghrthhnvg
    hrshhhihhprdgtohhmpdhrtghpthhtoheprghrnhgusehkvghrnhgvlhdrohhrghdprhgt
    phhtthhopehgrhdqqhhlohhgihgtqdhsthhorhgrghgvqdhuphhsthhrvggrmhesmhgrrh
    hvvghllhdrtghomhdprhgtphhtthhopehnjhgrvhgrlhhisehmrghrvhgvlhhlrdgtohhm
    pdhrtghpthhtohepqhhuthhrrghnsehmrghrvhgvlhhlrdgtohhmpdhrtghpthhtoheprg
    hlohhkrdgrrdhtihifrghrihesohhrrggtlhgvrdgtohhmpdhrtghpthhtohephhhimhgr
    nhhshhhurdhmrgguhhgrnhhisehorhgrtghlvgdrtghomhdprhgtphhtthhopehmrghrth
    hinhdrphgvthgvrhhsvghnsehorhgrtghlvgdrtghomhdprhgtphhtthhopehlihhnuhig
    sehtrhgvsghlihhgrdhorhhg
X-ME-Proxy: <xmx:GHRVaE2ztrykHrO845LnrB_kDRGu6HjcakoEtt1-R9V3YZYPuMq5EQ>
    <xmx:GHRVaPDxwNS0TkWgpyiTKxSUkAOOrD-IR_MNrQJebNFgdGbps-5WHA>
    <xmx:GHRVaIhnCFW_qJeI92B2GHGaspvRQKCWyCa_tRHKe118wdbOJOPBzQ>
    <xmx:GHRVaDrh3qO-mfN_YKd77mhOxmkzfcNoa7PVflcDWcvf9UJQw7Dg9A>
    <xmx:GXRVaDacloe4o-74nInrPcOlIDTw9uVnb4kWautxLfNDXk2axhPuPw-e>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id B1FE8700064; Fri, 20 Jun 2025 10:45:44 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: Tfde9bdcd63e30167
Date: Fri, 20 Jun 2025 16:45:24 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "ALOK TIWARI" <alok.a.tiwari@oracle.com>,
 "Arnd Bergmann" <arnd@kernel.org>, "Nilesh Javali" <njavali@marvell.com>,
 GR-QLogic-Storage-Upstream@marvell.com,
 "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "Quinn Tran" <qutran@marvell.com>,
 "Himanshu Madhani" <himanshu.madhani@oracle.com>, linux <linux@treblig.org>,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <44f9b2b8-fa62-483a-a821-f2a18d5832c9@app.fastmail.com>
In-Reply-To: <9f1486ff-2351-4002-8ee6-e2cfad354251@oracle.com>
References: <20250620113919.3974443-1-arnd@kernel.org>
 <9f1486ff-2351-4002-8ee6-e2cfad354251@oracle.com>
Subject: Re: [PATCH] scsi: qla2xxx: avoid stack frame size warning in qla_dfs
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Fri, Jun 20, 2025, at 15:34, ALOK TIWARI wrote:
> On 6/20/2025 5:09 PM, Arnd Bergmann wrote:
>
> remove extra " " after pd

Done

>> +		    "Failed to allocate port database structure.\n");
>> +		goto done_free_sp;
>
> -> goto done
> as pd is NULL it wont called dma_pool_free at all.
> dma_pool_free, trying to free a pd (NULL) confusing.

Done

>> +	memset(&mc, 0, sizeof(mc));
>> +	mc.mb[0] = MBC_GET_PORT_DATABASE;
>> +	mc.mb[1] = loop_id;
>> +	mc.mb[2] = MSW(pd_dma);
>> +	mc.mb[3] = LSW(pd_dma);
>> +	mc.mb[6] = MSW(MSD(pd_dma));
>> +	mc.mb[7] = LSW(MSD(pd_dma));
>> +	mc.mb[9] = vha->vp_idx;
>> +	mc.mb[10] = 0;
>
> seems Redundant, as already called memset ?

Done reluctantly: I see the driver is a bit inconsistent here,
with some functions skipping the memset() and initializing all
array entries, some functions do both, and rely on the memset
but skip the individual fields.

The compiler should be smart enough produce the same result
in any of those combinations at least for small structures,
so to me this is mostly about documenting what fields are
actually being accessed by the firmware later.

     Arnd
