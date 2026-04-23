Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DC6A2FD7BC;
	Thu, 23 Apr 2026 11:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776944820; cv=none; b=jEZRX4N6U4Of6T4Rqv85olCudXwtyMFkPk1+WsFAacB90zofwTwxo9yBmDdZUDQ2X7Lm9EmhOAE4iJqHnVFeJgib02MFVuQn9pXtbQd1dS0N6e2ocOFCVr9MANM0q4Ih2FpKalzGTDAeejJ+rXZ35py9XRwYitoRa0IefwrluC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776944820; c=relaxed/simple;
	bh=lAH+tMgsReb5YVC0CmXAwj1oMmvhUfKDEdN5ypoXL7A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PbCfqZ58WYHmhxLKouG736JIRBhpFGj5+wMcqZJpowuSVRvm2X1VgZeMLwnYee2XKThyGcspD/fjKZYeK1BcSZhXAlv9I5xxx3Xq4YiKsaD+6N5UK2DUPPufoMYlKTJ9pKtJk588YObOR3XDnzh7OZUoqEuKFRcDaV6/cxtYoEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VR1KrBY9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VR1KrBY9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DA02C2BCAF;
	Thu, 23 Apr 2026 11:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776944820;
	bh=lAH+tMgsReb5YVC0CmXAwj1oMmvhUfKDEdN5ypoXL7A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VR1KrBY9S+BKA8k7jOQ4sG8OyVJgAf6WtmbQeHmDYORbAMCr5fh7SpjfbTE9eZZxN
	 rzHKzoxMGlqJJ6utbOn/T4Sg/BVYFXnKlhovHu8Hnk7nwTRdzPnxczM8ncMLTxEa6I
	 /wlmNFzw1+ZOcQ1W26d+BcC9P5CfcCJA+EMtq0sjeFT9AB9b0m6Iv/3V0CegpKOGx5
	 1208mxBZFaUodfH8KMVxqvI0AsIzojqJrDysFUAKn835F3B5vL8ltK63r7S484cONZ
	 uECR5DDXheZKCldg6TyodnS/qboWOInXZISKyaXrr7Qv9jezXVe3Vx6epCT3FOHNwp
	 CU3ro1rSzVU1A==
Date: Thu, 23 Apr 2026 13:46:54 +0200
From: Christian Brauner <brauner@kernel.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-block@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-nvme@lists.infradead.org, bpf@vger.kernel.org, lsf-pc@lists.linux-foundation.org, 
	linux-kernel@vger.kernel.org
Subject: Re: LSF/MM/BPF: 2026: Call for Proposals
Message-ID: <20260423-auseinander-steigen-b80ee53079a8@brauner>
References: <20260110-lsfmm-2026-cfp-ae970765d60e@brauner>
 <81033e57-99e5-43f1-a6c3-c363e96f9c9f@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <81033e57-99e5-43f1-a6c3-c363e96f9c9f@acm.org>

On Wed, Apr 22, 2026 at 01:29:56PM -0700, Bart Van Assche wrote:
> On 1/10/26 5:24 AM, Christian Brauner wrote:
> > The annual Linux Storage, Filesystem, Memory Management, and BPF
> > (LSF/MM/BPF) Summit for 2026 will be held May 4–6, 2026 in Zagreb,
> > Croatia.
> > 
> > LSF/MM/BPF is an invitation-only technical workshop to map out
> > improvements to the Linux storage, filesystem, BPF, and memory
> > management subsystems that will make their way into the mainline
> > kernel within the coming years.
> > 
> > LSF/MM/BPF 2026 will be a three-day, stand-alone conference with four
> > subsystem-specific tracks, cross-track discussions, as well as BoF and
> > hacking sessions. Please check out:
> > 
> >            https://events.linuxfoundation.org/lsfmmbpf/
> > 
> > for further details on the venue and hotels.
> 
> Thank you Christian for being one of the organizers of the
> LSF/MM/BPF summit. Will a schedule be made available before the summit
> starts? A link to the 2024 schedule is available at
> https://lore.kernel.org/all/20240510212132.83346-1-sj@kernel.org/.

The preliminary schedule is accessible here:

https://docs.google.com/spreadsheets/d/1mGEdDrWskp7Ua91jGXzquQGinorcD58DAVXhOiRp2Gg/edit?gid=1852749899#gid=1852749899

It just hasn't been liked on the website yet.
