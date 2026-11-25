Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.157
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795639027;
	b=AB8oFsDZ6HQAcKIxS4r4ssnt9BPYWVU25Jama2UlZ1F0Y9WKxAoNnhK2YVppVCZjgBnR
	 lElK6UbXbKVmaFyXW5PgPxdWZ3vfMUJOQOkvrM6K70I46tUYeeo7PnxYUu98lV6Qk/KU+
	 nMtAf1uMs0WzNxZ6VJzcq7A/3vTlGyH0gq4hLvvyOAN4PKIIkTMJVn47H5OrCOY9exm9U
	 TJcnUyeIEm5XoySOA+i4wAd3t51tvXuW4j8WylsTXId3A6WtAUEFnTYN6LV9QLn9J5Ud2
	 WPwqzjkR0D4YulfKg4u0mn6Hgwx7j7xjIClc01v0rJ+FXHxKZJh0Vc7MqPkmTnE7LJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795639027;
	h=DMARC-Filter:Received:Received:DKIM-Signature:X-ME-Sender:
	 X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:Date:
	 From:To:cc:Subject:In-Reply-To:Message-ID:References:MIME-Version:
	 Content-Type;
	bh=eqJ6XZKGRtlH/8E+zhGGZaWzpzwDBPjUVdzg/9BKOAk=;
	b=RQEQI82RX7tL/2EMz2JXpHffgEo79jH8Hn54pqtco3lOYlcg2obVmpz8hY0EYQbROh/N
	 wzoCSDhrrttly1TbIXjJw6g2Ifo+ywF3e+HQV7RZnR1+f3gLADl2sgKvfrEaoz7KD7tvE
	 nO1jK0AZcePBgU412ASN1BfO3IQtDfsnuQa0KkiJHHC0anATd0OrQsEpVawA1sEoz00rA
	 qOQmcq4cYSP2ZyxkmKcxZVkUfOWOQqNhZstFxi+GCd6zMPtAz7iyOP2pfoLb4xiM/JxII
	 OS22ZNyAczss7bishtWTP+7G7/cte/6oXcVu9LAr3XDhiLITbir7gxRzqfrcrKTGneg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=linux-m68k.org;
	spf=none smtp.mailfrom=linux-m68k.org;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=lydh+8Xk;
	arc=none smtp.remote-ip=103.168.172.157
Received: from fhigh-a6-smtp.messagingengine.com (fhigh-a6-smtp.messagingengine.com [103.168.172.157])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C0BF606A31E;
	Wed, 25 Nov 2026 20:37:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4C0BF606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=lydh+8Xk
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 54F6D140033D;
	Wed, 25 Nov 2026 15:37:06 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Wed, 25 Nov 2026 15:37:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1795639026; x=1795725426; bh=eqJ6XZKGRtlH/8E+zhGGZaWzpzwDBPjUVdz
	g/9BKOAk=; b=lydh+8Xk0MGqTZ/BJX2Z6Cs2IK3aS3rdIFEUFPRJMmrRD/wuVhB
	s1KqtK8dLnflf9nqM6ZBTh+WM6U8miNmsWsHdbIVJGYyPfgjMeR2PhBF3Rps2Rwd
	9H/S7qEUh8Tz8dhUiazLyBVSgp4hdz2/+GOsmstYU8or/sfa5ioig5CM2TTT9pBa
	AKIDPbuxMdh7dG1KITpwJD1nIRqkP4cgeNBTshaP53BuTK4Mtoop29y5voVhobXI
	B3cpsRuYvx8ToPmrPI1uyVWBICwdL9AzLPJaEL8UsrK5QyRaRw2xgFSv1EVuh8u6
	UkXx0NKb30Teyw5jbuL7DOnsGwkKuVl+UVw==
X-ME-Sender: <xms:8UYHa6ig08f3GNJljEQUfAewZu9BfIB5djjvBF8dajcYwXS24ZFAvw>
    <xme:8UYHa3uj_A-_mDvRpKSf-zu_WwedIfdRHaaI4pGLP3NWKL5y2owXRbNA9SwN2vKIJ
    VHDXi-B6VMHBMsG6caUgTOf_ES-MB_PDt7HEnVAz7uaX9o1VfhaRkQV>
X-ME-Received: <xmr:8UYHa18AxKLUpT58y5x4kIieiGlnMc9HT0GmcnacqzrzkvLuquVzBxMD5q5v>
X-ME-Proxy-Cause: dmFkZTE6oC/3NKlSbtcdhhLp6bo7OIaW4366gDdTfMdjm9SykY++SSM/TEWaGAAvy35KMC
    lxAWG9OufPRkcrncDlANxGdF47KxYiNt3+LcLZ1AdVjC7RH+J95hEfatvaWouFhxcisjyC
    41l0S8n7L0LE7Wph1l0Q2S3YU4YHhBRpfYkAz6YOfFXts3zpBRv1j87Y73AlUgrJdxB26H
    7RI605+wYb+fDH6JG29F/k5f6AdtzP66K/QeDXBNSLfIOUC+0Tk7vLbPW3bzgEGJEstx4h
    qG2GkcZkx5+A4ACW8HzP8mU6tIhphjcuf8nTOb0kys6y4vZ0pLugHkrmP1GQKn8pNdm9aI
    GtVyIsu2iZELtCL46Sdmcb8gIj7WfwQJwtRw1hHyEikVO7Q88g8SwxeFzz39iQ8tnc98mL
    N8tlqzt5jyd47t7BKz1eyO/olFKTePXfIYHn6rARmmgmPsyxwukb5axoR3xXWOyTH06SuM
    GW4cmZEHBG5CGQ/DKhq0bLzc7I/L25fe71YwM6IZPZuMXHMYBBl0edjyKNIT98eZyCbefB
    A0AC9BZMC1OBbN5+2hlPII1Niq0o0C4B8LQZtw3lDnLgUazcpau3eQIq1wqhw+VEdEbnK2
    B2dghq2G8sDogFfQzJqfaledsnqYKoFuBTNWS3iraTzpwvkmUy1YBSoSPIgw
X-ME-Proxy: <xmx:8UYHa9Z1I71tZcRG2S1kg-B83JJ4FUuIzud4DGneq4j8Y7nBCSKMOw>
    <xmx:8UYHa7q9tmD5nRcKujQB23nR2oFYITBHF3j-3Q6d4_wp9pY0jNe4XQ>
    <xmx:8UYHa60rPMDgYTXlyTFPhLIwnI8z0Z94CAJ4QMfUcH1mh960w9otUg>
    <xmx:8UYHa7mOwlEa6ebVONYY1-LvPOVpDExs_TTkVz51OrlKAzQuz6R4aA>
    <xmx:8kYHa82sHtck2rdJsn-QlEH_StK340qt5XURJmTLYZkG7kiNfi_TMUKR>
Feedback-ID: i58a146ae:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 25 Nov 2026 15:37:03 -0500 (EST)
Date: Thu, 26 Nov 2026 07:36:56 +1100 (AEDT)
From: Finn Thain <fthain@linux-m68k.org>
To: Arnd Bergmann <arnd@arndb.de>
cc: Andrew Morton <akpm@linux-foundation.org>, 
    Bart Van Assche <bvanassche@acm.org>, 
    Geert Uytterhoeven <geert@linux-m68k.org>, 
    kernel test robot <lkp@intel.com>, oe-kbuild-all@lists.linux.dev, 
    linux-kernel@vger.kernel.org, 
    Linux Memory Management List <linux-mm@kvack.org>, 
    "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, 
    "Martin K. Petersen" <mkp@kernel.org>, scsi <linux-scsi@vger.kernel.org>, 
    Nilesh Javali <njavali@marvell.com>, 
    GR-QLogic-Storage-Upstream@marvell.com
Subject: Re: include/linux/compiler_types.h:631:45: error: call to
 '__compiletime_assert_433' declared with attribute error: BUILD_BUG_ON
 failed: offsetof(struct qla_tgt_sess_op, atio) + sizeof(u->atio) !=
 sizeof(*u)
In-Reply-To: <cb52daef-8182-1821-60bf-ccb6475b613c@linux-m68k.org>
Message-ID: <8109e47f-b7d7-80a6-6a0c-73613683b495@linux-m68k.org>
References: <20261121034304.2dPxVKzk-lkp@intel.com> <0b947a72-7a68-9bde-8b0b-adb539f09a8c@linux-m68k.org> <CAMuHMdUxYwD2t8zrqs4QBCtATOtf9xE83Djo0g7qbNFGSCWAQA@mail.gmail.com> <669b9ce8-bb33-f7ee-1087-88c1e9d3b610@linux-m68k.org> <8a0f78e3-5483-42a2-ae27-473bbb6de915@acm.org>
 <85e103fe-acca-0880-1be3-cb1e7f79f9a4@linux-m68k.org> <f0ec2845-245d-43ac-9c96-242e0d1d11ea@app.fastmail.com> <9120b892-6a31-d161-381b-809191017bdc@linux-m68k.org> <9ada54e5-d80a-4d3c-a491-87e7a99f2ac8@app.fastmail.com>
 <cb52daef-8182-1821-60bf-ccb6475b613c@linux-m68k.org>
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


On Wed, 25 Nov 2026, I wrote:

> 
> Perhaps there is a way to alter the struct layouts in a portable way (so 
> as to avoid the build failure) but it's simply not worth it.
> 

To be fair, your rework suggestion might have similarly negligible risk to 
my "remove" patch, if you could obtain your desired struct layout without 
altering object code...

> There is no actual bug here, that affects actual users, to justify the 
> churn, or the complexity, or the regression testing effort, or the 
> fruitless discussion to-date.
> 
> If there was a maintainer who cared about this issue, perhaps that would 
> put a different light on it. Maybe.
> 
> As I pointed out in March, there is already a comment in the driver to 
> make the bogus BUILD_BUG_ON() effectively redundant. So, at some point 
> in the future, when I can get interested again, I will re-send the same 
> untested yet risk-free patch that I sent back in March, to remove it.
> 

One reason I'm against reworking this assertion is that it never did what 
it claimed to do, so it's probably worthless.

Also, the kind of bug that could be caught this way could be detected 
using automated testing, so it's probably redundant.

Finally, wouldn't it be better to feed the hardware design to an LLM and 
validate the actual constraint that way? Guessing at all of the ways in 
which actual constraints might be violated (i.e. new struct member in the 
wrong place) seems likely to miss what matters and check what doesn't.

Since the vendor probably won't allow us to see the hardware design, why 
not use the (existing) natural language commentary in the same way, 
instead of translating the comments into assertions or tests?
