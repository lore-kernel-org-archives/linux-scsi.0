Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 034593859E8;
	Mon, 16 Mar 2026 10:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773656445; cv=none; b=hBLZ+jqShbROh7euT4kIrICI0UblNsE8D+emGKPsjP9d4mhd+zIa/ibnJ8jnu0Tpj6Sg2Ng27K0i2IJ6po1b2a/r10tx1fVCpJiQZ2P6TUQGej/sld1X2tz1U4hRRbn/cN6FZmuGQr8D0DvHiLbitTgwtX+2njvI7r1Q4h1RLbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773656445; c=relaxed/simple;
	bh=uBu8mLZ+rpt9hHO2zebFJ320GkM1XA33y5mwSl91uXs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ox6UpvQqKyIkLpUH3vCLxPEy8SI8r5w6B3by97RRGjSHrp9tScSf9K42g/mHpz6YXSf3pH0CI1JAa2l/GqPyQI9QVr2TogWpAurvomtJQR1vpdrmDmSYKg1+7QF9QuGWzIgokdtQkDe/+8pqwvNydEscKbIIW2pkdmHLEf3Lprg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UDAiyRhI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UDAiyRhI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55DBDC19421;
	Mon, 16 Mar 2026 10:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773656444;
	bh=uBu8mLZ+rpt9hHO2zebFJ320GkM1XA33y5mwSl91uXs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UDAiyRhIXd16/3n5yLWqFADfP+XReuxaog2CvKttjDc2OI/QYNL4mwF+CIqtaO3Xt
	 nVCnBO2veL3YHcW2M/al3N7NNdtQxG3RK5+PzYo5tgFWUbuZFWefrbgmebUobo/FqX
	 E/7Jvw9UXMob3HhGf9JzB083MJy5xifdVTNGSQRDwUsTi6kWbzYkuEDGBF2AZBIsUu
	 EsisgrMjf/pATcn8oakB9tMAm9J+p2kpQDMFFBWhJesBObIOEijxO7+S/94gcXri5W
	 HwaihjisMgWQuD8/WV5d3I2sSQcn1UBREtld7gk+oOAmDJ3ndKabxfbaj/+Z5VDOrJ
	 jGpDyanxyr9GA==
Date: Mon, 16 Mar 2026 11:20:39 +0100
From: Christian Brauner <brauner@kernel.org>
To: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-block@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-nvme@lists.infradead.org, bpf@vger.kernel.org
Cc: lsf-pc@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: LSF/MM/BPF: 2026: (V)FS: Second Round of Invites Sent
Message-ID: <20260316-gebiss-drehkreuz-1f3f0e7a96df@brauner>
References: <20260110-lsfmm-2026-cfp-ae970765d60e@brauner>
 <20260225-aufeinander-kummervoll-1953a06beae9@brauner>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260225-aufeinander-kummervoll-1953a06beae9@brauner>

On Wed, Feb 25, 2026 at 03:52:23PM +0100, Christian Brauner wrote:
> Hey everyone,
> 
> I sent out the first round of invites for the (V)FS track.
> The first batch is also the largest batch. We will send out a set of
> smaller invites later.

Hey everyone,

I sent out the second and last batch of invites for the (V)FS track.
I've also sent out declined invitation notices. In case you have
received neither it is to be treated as a declined invitation at this
point.

Should any attendees be unable to attend because of... events... we may
be able to notify people on the list but it will likely be very short
notice unfortunately.

Thanks!
Christian
