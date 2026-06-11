Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 934A0407CEE;
	Thu, 11 Jun 2026 13:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781183999; cv=none; b=EMoTTEJhek7JhCP7pdzplbLruXV/puAzW4yho0wmMuEMarAyN7WxM7AIbWOM4yMRSkEJHzxbiu9ybmCAG2qOaduqZWIBOV+9+F6Wl9/VAgcxl6Dzr4Pnk7RT95a8G+z5Y8G2MD8mbVsdtAW+GP+uWj46bOr2EzPNvLQDRIACCCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781183999; c=relaxed/simple;
	bh=jkf7PLV0upcyI1Dd84GqmFNHJztO+enETv/XDRZQW2k=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=r0CuT69Q0/QJ3+DRon1Uj0z/9GC2NU7MKlT8LWSVyJVy8ucHPkdjGWF+DId1Q9Adc9JTwdHurCtH3I36IY67feXFeidRr0cAIcWZDFsw9x+jKG3+tnGBCrgV0YjEp7OY6FEFirC1jPSkykbsn/eshQjs+QBDXAGS3B7TcZpfsYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=az6+FCSJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="az6+FCSJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E951F1F00899;
	Thu, 11 Jun 2026 13:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781183997;
	bh=HzSfmuG8HSRtT7yTvLdtj8uUzcdbOmNCX6VgX2+ZSgc=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=az6+FCSJeNRPvp2jSwfY5GPfCICJMz6tD8XJsUaIJFon6huZUa7ZgGK3eHluRu1cP
	 KqNi7SrgLZ4WXVoWOJCGhuacmVwOlioMRVgzLNwcFSrqpA1f3ctFrDL0Rua6eNd9pJ
	 JT/MgCvjeShIVB1FpjplYOcHzB2E8/2KIRNMVLFO0FdrhlQ1vh7OLQP2pzvLCAlp9P
	 hGwp//kS0Kp0t3Dz0/wqgO0JfgJ6cokMRE1zKV2TCc0Hvb1iyqwlD0+vYBlYq4XMvX
	 XfCLhuE99bWhg0TeGT54LKJ9wLhTO5go3Zex7j444T3MIQlFPCRqCtgO0XgfZvE0GG
	 2dsF15UtGPcUw==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.phl.internal (Postfix) with ESMTP id 37A3DF40087;
	Thu, 11 Jun 2026 09:19:56 -0400 (EDT)
Received: from phl-imap-05 ([10.202.2.95])
  by phl-compute-04.internal (MEProxy); Thu, 11 Jun 2026 09:19:56 -0400
X-ME-Sender: <xms:_LUqaqlOF28RYjS5jt44tTD33hbN0YcY038XC2bztCppAPognrUmqg>
    <xme:_LUqason8yqIfQYbkrWes0j4KZIN9WshX00yVGrQ4ImV1-En0O_-TmeOyPNGj6Fq9
    Z2YDonF1jHRJ5UFs5wSxcPtQNiw45DnG4BroX00Ni6ALbO15GB7Fhg>
X-ME-Proxy-Cause: dmFkZTFRFIXfbZ1jH7v417QDQYwgHKoJj3SUnbbsIsD7eEAdDY7DGyFi6UVC4NlWskEYeY
    K/cgBcIs1I3eQyHQMong6yAyjh/j5Aaevhg4TPCk5GHFxbJk4t5sgqtxTYnWgVmFG6TF9u
    svMTK0r9f/K4FYhLaC3WdAlZ3Vb9B7tj8mn09yVm0IdJuz0HP6REkyZVqf/74W+ipgMdGU
    hTYcE7omokxjNIbXQFaJWyl7WQvrKPEBxkYUKILiud15MVLbgnp0fpaDn/PwBy/V9qXAbY
    y8OzDShkU25V42j+9yLjjc0MXYaDtDZ1d1VTF/IRK2Ud9GLhZ+QyU1x4dmLAn2v0UL/2l7
    S/9XiOEcmn5iz/Qk7ftRxiJPntBo8cIpOPzdVdZwf7eQ+vfcUiOl/MCekPQGwCuommKz0v
    D30MtC+7KaVipXJVgr4A2gY04lbWS7qM5AfSM3pn2bAYkpJoA1zsAKzXXC5LsM22zmN7QT
    gRhzFL6Xzk6B0YeplypDo7FYog2OZiv1dbVTjNiK8PLPuodUURUQPXau8HU8hwvgx+r73u
    CWPS1WdhkUjbq6duNA5CX/+tVswIiIi8vfCiYFZQY7sfQt9354xuqfc2XiIeXDYrmS8MGc
    G8yHAv4aaubO2S/omkjQBrv9P7/bcwWKXFxypEl6X3FST6xzs29lYtrvM7vw
X-ME-Proxy: <xmx:_LUqaiJ-AIrx7Xcbt0vSv6bhKweMZpJaUoOS0jSoehPitCqrzpK7wA>
    <xmx:_LUqaqTBcQErfMg4EeEGn6SNSAL_vb1r1si-rt_A3tVpVQ6Yt_w_BA>
    <xmx:_LUqaqrUa_rlLtDeh35v0mmg6xAjfeR1_DiXEc5DCQTgEYB3ueBxIQ>
    <xmx:_LUqavoI4VzIFdQtLucF_i_CbpABdCjBcAvbwpXsroL1HnQ7NdDDjQ>
    <xmx:_LUqakN8QzrsVHL4rH6b2yCX3mB06GGq_RvoImCmpGPF6ubIaKwPKL-R>
Feedback-ID: i36794607:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 1CD18182007E; Thu, 11 Jun 2026 09:19:56 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: AAFy17evDmO7
Date: Thu, 11 Jun 2026 15:19:35 +0200
From: "Arnd Bergmann" <arnd@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org, "Anil Gurumurthy" <anil.gurumurthy@qlogic.com>
Message-Id: <bb197d6a-f975-4616-8978-c78ae3cf20f2@app.fastmail.com>
In-Reply-To: <20260611131023.41FA21F00898@smtp.kernel.org>
References: <20260611125601.3385418-1-arnd@kernel.org>
 <20260611131023.41FA21F00898@smtp.kernel.org>
Subject: Re: [PATCH] scsi: bfa: reduce kernel stack usage in
 bfa_fcs_lport_fdmi_build_portattr_block
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Thu, Jun 11, 2026, at 15:10, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential 
> issue(s) to consider:
>
> Pre-existing issues:
> - [High] Unhandled error path leaves the state machine stalled, leading 
> to a leaked fcxp structure and a list_del() crash upon port offline.
> --

Correct, this came in from a7a11b6cfec2 ("scsi: bfa: Move a large
struct from the stack onto the heap"). My first attempt at fixing
the new warning was to take the same approach that Lee did at
the time. A dynamic allocation would have been better for the
stack usage, but I ended up running into the exact same problem
as the earlier patch and decided against this. I had not realized
that this was already an issue.

As I had nothing to do with that fix, I'm not going to attempt
to fix it, but I would suggest that the maintainers take a
look at fixing the error handling. If the same method is
used in bfa_fcs_fdmi_get_hbaattr() and
bfa_fcs_lport_fdmi_build_portattr_block() to avoid the
large stack variables, my patch is no longer needed.

    Arnd
