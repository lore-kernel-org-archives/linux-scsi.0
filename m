Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.147
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795491123;
	b=yqRkw2cqkNSWGnrT0CU1hbZhjyGiUelrT06FS9prSSn0nTpo0EE5okOYQe/FPdFOUZXZ
	 yVxMXLju+6Or/jIbz6QxRYd/C4JNeuwYkkR1Dq87i/trKZD5teY6O1qj7xZ1CS7vAkTl/
	 6KgGEv0FZUbRcLKVnqK/rVYeX2mikVoLfAVZUQr14BVGTuusBfTyH6wnByJ9+U3y0HGBF
	 PToz2+flEZe/v3b/q0PbgDIpOVNG3nIPxpZvB15isRRUMAMZj0G/sqdtRiwdsa0oKlLPQ
	 87EB3EdPBYBJ7iRI86x6lq+aFWUSxk1JIyq0fMUsnPUO16P9Og85d+78UUud7/hKGgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795491123;
	h=DMARC-Filter:Received:Received:DKIM-Signature:X-ME-Sender:
	 X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:Date:
	 From:To:cc:Subject:In-Reply-To:Message-ID:References:MIME-Version:
	 Content-Type;
	bh=kLoOysGNtZOXt/ESdOdZUsUDPWGwGSckCxOKgDV/zUQ=;
	b=V2DnT0brLkvEziSvKydtAjK9Su4EEX8KnWsyvDxy64SLOoqim4FJWxt/aZ3gAv4cDymT
	 KW+ftgnLTUiX20jJ/5Zyxta7aUMSgCCCmJH52je/LJT7tdyehj6OKnE0Zc31V446CEREI
	 +eaO7ZqTJqdAm3KmAaPYwlyesUXA1f9abNMBx53MkF9xXpTtSG32tNDrUuCFOhxwtAW12
	 Il08yuBnzuvUnu0VvAW2srxvtjFp2fG9dPLvx9J5pBWxzjNW0fhg2OgwSVgMAMd9RtX0a
	 etCpfdeflgchMl0KClHBYkUHoN+RKnqPPAExLYFgjIhInYk02jGBbZWoE8MPRf3d1ZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=linux-m68k.org;
	spf=none smtp.mailfrom=linux-m68k.org;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=alvoVMjB;
	arc=none smtp.remote-ip=202.12.124.147
Received: from fout-b4-smtp.messagingengine.com (fout-b4-smtp.messagingengine.com [202.12.124.147])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3ADB606A31E;
	Tue, 24 Nov 2026 03:32:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E3ADB606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=alvoVMjB
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfout.stl.internal (Postfix) with ESMTP id 494051D00373;
	Mon, 23 Nov 2026 22:32:01 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-09.internal (MEProxy); Mon, 23 Nov 2026 22:32:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1795491121; x=1795577521; bh=kLoOysGNtZOXt/ESdOdZUsUDPWGwGSckCxO
	KgDV/zUQ=; b=alvoVMjBTX/NhdGQNY67fq6toV3OveCnp8MX6fU00cHvAWxPtC4
	ympw8pvh8bdxyvT5bi3/2ra7zcPOe/wmLVS8ATj/gc9iPzIr+IYO9zlXpwrGCMWI
	rgCa4KE4bg033482/hBxGda2xGIRbYb1tQq4hLirbfMid6xJkLfw0xlG4182WM4k
	oxeB2/Xm9FZv4s64e9GatzkU1zp4B+g0KjX1L15GnESJZLqS/5ILMbxdwBIkjWHe
	vl8YQHkRS30QcFuifqWpM3gguKlxzNwwbVV/w5Gify+F60Jj6rlSQ/gkhYcoJ58r
	XLrcpnZcqndBeNJUCd7RODSWTkRHl0RE2hg==
X-ME-Sender: <xms:MAUFawWGOnSUhWCK0n74bj7S1daW3O9f576fnuZBdtB2EcJdtRQvsQ>
    <xme:MAUFawdh1Oq1_8bgtEdvN2rh8_xUeMjHNPlGbeEdfIm0rLylKVuY1fhblFZavmMsi
    aKJzVjTZY_cN7_Sx-Us_5uFIHv3RgfyOANrbzf9l_jc-6Kycz5etmAF>
X-ME-Received: <xmr:MAUFaxa12B8uS99cStoGsMwr3Isi2Nli3r3p_566paxqcxu05KiF3rhPgnYA>
X-ME-Proxy-Cause: dmFkZTEHpoa40k3wkgDvOYjTRBvpK2fU0Wmubuw4eAWknCsm19yPzDmblnHSkM0C/foDkE
    /gviTWxt7HQRY5tmC9+x10NSQo0Bq5MpD9NiZJ7ttBURF38crzHj43Sf6Z/S3cnKayTquP
    PKjvAHSMdyFHCMEE1T9j7G93Kkr7I+yDMMUpn7GfRFAIRiSZXM76u5jjSNIOIHZOB6frXq
    bjJ3B1+mU+Nt3nbZLZFZBsuem5iFzQIthvogegQ9qLmKoPl5H8LfO5i760EAdLiJ2bqtSv
    KaNgOXFO8n+CVAGQ7IGAOCRFzIX4CBPqojZY7xDeh7hXhQTL1/9VYK8v/FFA7yA5iT+0pJ
    BOdUtpePdwHKmey1pZteSsBtug5yTvXdetkn5a9A3YnjCwy264sUhaM/ZHCVwgeAOC9zHK
    8QzihtUER3Bb+SX9rIKiMoGFXDhFj3TDuf/6kAI/TEN8FtYcZN+XyKtnhdYVwJC+TcNkv7
    ooSAKkydzZ88wn+MvgEaE52JcfSFkejrUSYifUubi3KlttCP8TEf33jV2U6r6P8Fe1btqH
    l+0+SB9wX+5gDeyfyRpmHlDApLZQDv4yNStzUm/FtJNM8gNP1/LecqyJT/LpT9u4wyGUUw
    ZWfoEubPJ9J01lnKs6OYSAUDoKGHjVdWjAO7AyfpItAUQIN0sGh949DE22vA
X-ME-Proxy: <xmx:MAUFa0NJcAMrK4LX3DZf9VjPaWJ1uLZaOlQ6JPNpHp8OAiHPKbTgbw>
    <xmx:MAUFa_WctsRYYHPzbviSHjYtIrgXnYfkSm3hE1g3_BgZrHJ5FnOSzA>
    <xmx:MAUFa5IvTy3YsMBjmQC5_pD-7eUo9R7wpLZ6E_AMbaeCxxPpKzoiIg>
    <xmx:MAUFa6oDlywPuE8zIwr6hpSod7L4drQyEeIbXVIYF5BbzahKgp81mA>
    <xmx:MQUFa69GKEJBYb63VNweSDGNzNTTWOWlYWyYE5O0yuX0LS1PtMSn9EPt>
Feedback-ID: i58a146ae:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 23 Nov 2026 22:31:58 -0500 (EST)
Date: Tue, 24 Nov 2026 14:31:48 +1100 (AEDT)
From: Finn Thain <fthain@linux-m68k.org>
To: Bart Van Assche <bvanassche@acm.org>
cc: Geert Uytterhoeven <geert@linux-m68k.org>, 
    kernel test robot <lkp@intel.com>, oe-kbuild-all@lists.linux.dev, 
    linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
    Linux Memory Management List <linux-mm@kvack.org>, 
    Arnd Bergmann <arnd@arndb.de>, 
    James Bottomley <James.Bottomley@hansenpartnership.com>, 
    "Martin K. Petersen" <mkp@kernel.org>, scsi <linux-scsi@vger.kernel.org>
Subject: Re: include/linux/compiler_types.h:631:45: error: call to
 '__compiletime_assert_433' declared with attribute error: BUILD_BUG_ON
 failed: offsetof(struct qla_tgt_sess_op, atio) + sizeof(u->atio) !=
 sizeof(*u)
In-Reply-To: <8a0f78e3-5483-42a2-ae27-473bbb6de915@acm.org>
Message-ID: <85e103fe-acca-0880-1be3-cb1e7f79f9a4@linux-m68k.org>
References: <20261121034304.2dPxVKzk-lkp@intel.com> <0b947a72-7a68-9bde-8b0b-adb539f09a8c@linux-m68k.org> <CAMuHMdUxYwD2t8zrqs4QBCtATOtf9xE83Djo0g7qbNFGSCWAQA@mail.gmail.com> <669b9ce8-bb33-f7ee-1087-88c1e9d3b610@linux-m68k.org>
 <8a0f78e3-5483-42a2-ae27-473bbb6de915@acm.org>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii


On Mon, 23 Nov 2026, Bart Van Assche wrote:

> On 11/23/26 3:05 PM, Finn Thain wrote:
> > Yes, two alternative solutions were submitted in March (either remove the
> > assertion or rework it). The build bot reported the problem again in
> > September so I resubmitted the "rework" alternative. Sashiko-bot didn't
> > have much praise for that*, so now I'm leaning towards the "remove"
> > alternative. I have been advised to keep re-submitting, and I will do so
> > after a suitable back-off in retry rate i.e. 2027 or 2028.
> > 
> > *
> > https://lore.kernel.org/r/93e35f60-e465-7f76-0043-f997fe2ec8c7@linux-m68k.org
> 
> What an LLM came up with after I asked it to fix 
> https://lore.kernel.org/lkml/202603030747.VX0v4otS-lkp@intel.com/ can be 
> found below. One of the comments of the LLM is "This is essentially Finn 
> Thain's "Rework BUILD_BUG_ON() assertion" patch with your two review 
> comments from this morning applied". Sashiko reports "No issues found" 
> for the patch below. No Signed-off-by from me because I think Finn 
> should be credited for his work instead of I.
> 

Thanks, Bart. I'll take that as a vote for "rework". There is an 
associated risk though: I can't test the patch as I don't have access to 
suitable hardware. (Perhaps someone with such access will volunteer.) 

Whereas, the "remove" alternative doesn't require testing as it doesn't 
risk a regression.

I have a question for your LLM. Sashiko-bot said, in response to my patch:

    Similarly, get_datalen_for_atio() accesses the array out-of-bounds 
    when len > 0:

    drivers/scsi/qla2xxx/qla_target.h:get_datalen_for_atio() {
    ...
        return get_unaligned_be32(&atio->u.isp24.fcp_cmnd.add_cdb[len * 4]);
    ...
    }

I don't understand why the patch from your LLM did not raise the same OOB 
access concerns.

Adding a flex array to struct qla_tgt_sess_op can prevent new struct 
members being added in the wrong spot in that struct but can't prevent new 
struct members being added to struct atio7_fcp_cmnd. Neither does the 
assertion. So the "remove" alternative doesn't have all the disadvantages 
that you might expect.
