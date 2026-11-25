Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.156
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795591557;
	b=u91rFeahd4fUv/LYWrRho7Ck3eDNBcRB6YaguNtkPsjXvVGDqJRsHOJ4F2R33Vwqa9Os
	 dKtV+FxioKIB0+eONfXPkaoDj2umD30VnNjCrgRaaEzfSp1xDRqNE/8dacicFZrxbUsKj
	 YkTj2HleRnLKMVxdnlpk1LEc7K3m9WG79f2+wDvww0iPccRW+eru16augZaPFK18F+3tu
	 cgJRubtrOQT37ML2RmvPeBKOi5AG9VXgpvuj9fbPEM17GWt6jOY1Ak+IMRfpnDhIdq23H
	 Yr+2OtirGHRjZXKpC6eWCbcIcoOK37h5W3hfRPiyBgGiN84tV/IToTdvZrJmd2pEL8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795591557;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:X-ThreadId:Date:From:To:Cc:Message-Id:In-Reply-To:
	 References:Subject:Content-Type:Content-Transfer-Encoding;
	bh=areUyV5IGaUVKzShNrXTKucydKXnSUiEsCYf0gfgVEI=;
	b=qP47eWb/2LLutWOaTjp3b4PhqhnBEOZiK4W/vxS4qn3mfCaPc8NaICBVlCjHv8oPr7/A
	 HmXCdxhL6hhnOH3G6PM8n/7o9PFQVFtRaU+JcIDgzRiIkFZgX/qYi3jbAymRx7E5Z/GlW
	 AXMiukyjAqiPj/hixZLjia6QYsjnxgJIs5xtl69rHlqUh45m3CIV8lAO5TOCnDHr971BN
	 IA8ig69JoTj6G8u9AGguWI9u3kPlHZCTagnF+K0mOGpxuhwceWmsVC1M1+UlLM7vTGLRJ
	 2GuH850+fWzA4a1wZ4bJhFuoZZMX4Vi1bv3xpQTtzWRPmFFysyVh7UNyynGjmhVRSwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arndb.de;
	spf=pass smtp.mailfrom=arndb.de;
	dkim=pass header.d=arndb.de header.i=@arndb.de header.a=rsa-sha256 header.s=fm3 header.b=NXmQYgQf;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=mhCAzoiz;
	arc=none smtp.remote-ip=103.168.172.156
Received: from fhigh-a5-smtp.messagingengine.com (fhigh-a5-smtp.messagingengine.com [103.168.172.156])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFA2A606A31E
	for <linux-scsi@vger.kernel.org>; Wed, 25 Nov 2026 07:25:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AFA2A606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=arndb.de header.i=@arndb.de header.a=rsa-sha256 header.s=fm3 header.b=NXmQYgQf;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=mhCAzoiz
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfhigh.phl.internal (Postfix) with ESMTP id CDFC0140042D
	for <linux-scsi@vger.kernel.org>; Wed, 25 Nov 2026 02:25:55 -0500 (EST)
Received: from ams-imap-03 ([10.64.2.23])
  by ams-compute-02.internal (MEProxy); Wed, 25 Nov 2026 02:25:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1795591549;
	 x=1795677949; bh=areUyV5IGaUVKzShNrXTKucydKXnSUiEsCYf0gfgVEI=; b=
	NXmQYgQfDBGtJJqA6lvVi0OJb8T+mYZTwOFSzroe6/oEumlIDMoOoBVQyvMptNTV
	M5GurofGyGzpx68W0qorKdy4R/xlR4nuXhn5n/LsH91e9i9qdE+OM4swCxDK2pRe
	WHQkVYGq8tSKTHETaOuAO3Z8FoXI6HFIavffF537didW3kxqWoIcunaoADoB6sBk
	yi6VVuji+82nyUQ5kT3qmYipitW/tzddzJkvxNyS6f8AxnBir/6VtMjMTwgnHSiQ
	fqNcyG9LOxd9zhHwAqiRihNk0wARFFva+wqOs9XsI5BtsVhAOTmrFbcVCXOgzrlU
	ea7/fsOx6TZ+BV1KuL4Nzg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1795591549; x=
	1795677949; bh=areUyV5IGaUVKzShNrXTKucydKXnSUiEsCYf0gfgVEI=; b=m
	hCAzoizhQKruuk5LmFRQz2d6hn2R1ksevvfdior23pCqGCzg/BtAT2Go8+nzfNeu
	RhfWZihDkz+MljWwSE93SDxX87KckydiZQ46rEk1J1v0qcB1d0cB1rI9d2olDzUI
	wEW3Cpuvf+NS+OX9f8B5I1O/dx6GdJkGRsbFI82xUidwKGBgrRTBva4FYeSRIaHU
	O8KX4B/vRG7cStt+nMcV6v7pKcplsDtDd2pGQB8dBO7/a7514VNMZyYxRi9WCXMu
	CjE4O8Zu1I/fE/ogBKLToJrDWtuMsN2lYbcPAeJL9C3Jd+fKi5MzDtAP8ML2mA8b
	5hnotpSYgwwpsDz7ICkWA==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=arndb.de a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1795591549; d=arndb.de;
	mf=PGFybmRAYXJuZGIuZGU+;
	rt=PGxpbnV4LXNjc2lAdmdlci5rZXJuZWwub3JnPg==;
	s=fm3:rsa-sha256:h5oiUJZYv7Dw5/dY6d3cRbVPL5tFofVznhtNmJBb1PnWHB3
	K2d1vc1SRwgdbA8M+tOkAZI+kbLCxibdUva3mzaspKEhedctmFglsZPnEl8/vF+O
	tgKBPj6kUUCRhXPqX+xassBEQEA2PPdyx1Wp7FbwB+12Ov/6v5mFYTKF6eWa3TTc
	wfolH10DEx6WnkzbALiJlVmxCia3cj1bFPgaRkqkJaZp6LOn9A7spdbDE9+nevfr
	IsS9TlfGc2SwvIWO0JHzJfTp6l3zu2q/mLzqg5i69U4oUde+mMHU5rR462ZzL0Fc
	Ot8mIsrwRZzVIMX0NakqWf4TV0LJvX17XziYxhQ==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-transfer-encoding,content-type,date,feedback-id,
	from,in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:ExiAzAI7ZIHsP3YwjQVuySluz/eigJ9CVIPb+SsDzuU=:qrbV5AJknoaupQ7zjDTbd8KS55zbU4af6v59P5+eBLQ=;
X-ME-Sender: <xms:do0Ga6GSJ35BWkDWp2fNfsaepR0LXFLtkcELH66KvHrOuyTtucC9eg>
    <xme:do0Ga2LokOoqcjP5nJFPguJ2BHyK7iWTQMVCke4O4omZ9B4ofEz_wGBv6K63B_cjc
    pXDSEAtTEPU56NTIZ6JUuo5HtZDg9fUERtxCd8FuaJKzkx9L1cpo2fL>
X-ME-Proxy-Cause: dmFkZTFZPq8SB5M/2S0yRtLGK0naaJDyEBcCAUFLXlW46+6wD18D2V7n4HzSTDFK4Zu1Kw
    lUGCTgRUyrsxhkAV+GljK6xyWGLMX6/po0bC24OTwhC/yvl3WbamZka1z3vH7mEIP2a+BQ
    r8p0BLhaxT1fv3BVPIZxSuB0NrZA8SBu7UDybYkk3RTzXTm6YGwzm2dav7RsHa/dNgBYEC
    YwhP8Dl9H1u3n5tS0gj4z7i5ITr+MMdY5LjaWGt24PBOj8tqd25FfpcFWI52efMkFvlXLN
    hV4JKd3Am4eI0FqzMtG0EnQJohRn7gz778dU+o0s+7DdgeK2+Wh1J+MUnGN1Rn7mO+ZdmT
    4IDUMWZnjGt8qxGM6Bg58JGW/gHqSlvYL/PjPdsE7xvOR26o0QuBGjASNOaeF8H8wOdYB1
    tFmBZa6aX9U2hB6XcOngW+Jz4N4UV1TZ6B1qZuMoRj0b34gf0HQ2W9sZ8KDO50YFmwFVpg
    IkiFPfqb3nAQUS5DTaqJSKCJnk0r57xA6VPqprSgrd/Nqg9cvFs3Y6jCaU4q27ehrWJuYr
    04vbgl0UUFovYY6lThKmmCbFbfM1dtQg+4wHu47UsA1c5cxR4XQ/2AoRhEUju0NKGbdOER
    ndp++75cb5519xDNdHN/VoHlMTe0mNy/RZGkWXsxNkmPj/HiG0T4SHCpI0og
X-ME-Proxy: <xmx:eY0Ga6S26rUQ_4ScmJ0YuJyWGJBwfBk5Umdal-Mg-2zuFJhou9LDNw>
    <xmx:eY0Ga3BprrMbUkf0SGxUGKcE0aMP0HZDS05EUNpxte60g9jvjbtX-g>
    <xmx:eY0GayvMvbdOEJERGQ8GvkbNHA_XslY0D_3LbzpTxmu1UIMgsFd5Ig>
    <xmx:eY0Ga18YTWLRREiBOs4qyRbQofRmBO4GOwowD1_trVaFXUz_EQ41bA>
    <xmx:fY0Ga3CeXFNz_4ixcslQkf6tb9EOKpaiJf7FkdwjRDMoKYnbLD2IBBDY>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id C30DD32A0099; Wed, 25 Nov 2026 02:25:42 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-ThreadId: AzzadY2dYG8o
Date: Wed, 25 Nov 2026 08:25:22 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Finn Thain" <fthain@linux-m68k.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
 "Bart Van Assche" <bvanassche@acm.org>,
 "Geert Uytterhoeven" <geert@linux-m68k.org>,
 "kernel test robot" <lkp@intel.com>, oe-kbuild-all@lists.linux.dev,
 linux-kernel@vger.kernel.org,
 "Linux Memory Management List" <linux-mm@kvack.org>,
 "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>, scsi <linux-scsi@vger.kernel.org>,
 "Nilesh Javali" <njavali@marvell.com>, GR-QLogic-Storage-Upstream@marvell.com
Message-Id: <9ada54e5-d80a-4d3c-a491-87e7a99f2ac8@app.fastmail.com>
In-Reply-To: <9120b892-6a31-d161-381b-809191017bdc@linux-m68k.org>
References: <20261121034304.2dPxVKzk-lkp@intel.com>
 <0b947a72-7a68-9bde-8b0b-adb539f09a8c@linux-m68k.org>
 <CAMuHMdUxYwD2t8zrqs4QBCtATOtf9xE83Djo0g7qbNFGSCWAQA@mail.gmail.com>
 <669b9ce8-bb33-f7ee-1087-88c1e9d3b610@linux-m68k.org>
 <8a0f78e3-5483-42a2-ae27-473bbb6de915@acm.org>
 <85e103fe-acca-0880-1be3-cb1e7f79f9a4@linux-m68k.org>
 <f0ec2845-245d-43ac-9c96-242e0d1d11ea@app.fastmail.com>
 <9120b892-6a31-d161-381b-809191017bdc@linux-m68k.org>
Subject: Re: include/linux/compiler_types.h:631:45: error: call to
 '__compiletime_assert_433' declared with attribute error: BUILD_BUG_ON
 failed: offsetof(struct qla_tgt_sess_op, atio) + sizeof(u->atio) !=
 sizeof(*u)
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Wed, Nov 25, 2026, at 01:18, Finn Thain wrote:
> [Cc qla2xxx maintainers]
> On Tue, 24 Nov 2026, Arnd Bergmann wrote:
>> On Tue, Nov 24, 2026, at 04:31, Finn Thain wrote:
>> > On Mon, 23 Nov 2026, Bart Van Assche wrote:
>> > Adding a flex array to struct qla_tgt_sess_op can prevent new struct 
>> > members being added in the wrong spot in that struct but can't prevent 
>> > new struct members being added to struct atio7_fcp_cmnd. Neither does 
>> > the assertion. So the "remove" alternative doesn't have all the 
>> > disadvantages that you might expect.
>> 
>> This is probably just a difference in perception: atio_from_isp and 
>> everything inside is clearly marked as a hardware structure that is 
>> meant to align exactly to the 64 byte cacheline, so it would not make 
>> any sense to change its layout and add more members here.
>
> If this driver is for x86_64 only, as you seem to be implying, then the 
> right fix for this build failure would seem to be Kconfig:
>

I did not say or imply that.

>> qla_tgt_sess_op on the other hand is clearly not a hardware structure 
>> but an in-kernel one so it is quite unexpected that one of its members 
>> extends past the end, especially when the other three instances of 
>> atio_from_isp in data structures don't seem to do that.
>> 
>> >> @@ -227,7 +224,7 @@ static void qlt_queue_unknown_atio(scsi_qla_host_t *vha,
>> >>   		add_cdb_len =
>> >>   			((unsigned int) atio->u.isp24.fcp_cmnd.add_cdb_len) * 4;
>> >> 
>> >> -	u = kzalloc(sizeof(*u) + add_cdb_len, GFP_ATOMIC);
>> >> +	u = kzalloc_flex(*u, extra_cdb, add_cdb_len, GFP_ATOMIC);
>> >>   	if (u == NULL)
>> >>  		goto out_term;
>> 
>> While this does make the current implementation more correct by having
>> the correct length, I'm worried that it just ends up establishing
>> the complexity more in the sense that extra_cdb extends both into
>> the padding and beyond qla_tgt_sess_op.
>> 
>> If the driver is still actively maintained, it would be nice to
>> reduce the complexity instead, in one of two ways:
>> 
>> a) make atio_from_isp naturally aligned by dropping the bogus
>>    __packed attribute, 
>
> I don't think I follow. "Natural" alignment would be at integer multiples 
> of the struct size, right? Moreover, the correct alignment for a hardware 
> struct is a question for the hardware vendor, isn't it?

I should have been clearer here, I meant having it aligned to the
highest alignment of any of its members, in this case alignof(u64),
which would avoid both the warning and the slow byte-at-a-time
access.

>>    so it is actually at the end of qla_tgt_sess_op
>>    as the driver was written to expect. 
>
> FWIW, I think __packed on a hardware struct is at least as desirable as 
> portable drivers are.

I can certainly see an argument for marking the inner structures
"__packed __aligned(8)" or similar, to ensure that the members are
tightly packed but can still be accessed worth multi-byte load/store
instructures.

The way the __packed it written on the outer struct, it only causes
problems but does not actually enforce packing of the inner struct.

     Arnd
