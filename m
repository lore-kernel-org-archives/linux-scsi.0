Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3EBD1E32CF;
	Mon, 16 Feb 2026 14:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771251918; cv=none; b=DVfNabD832NGY8ShzSLZQgKpPlz5MVGx1xczikiTawOpo92jEXg0lmjqcc3C5RjBfuNalRbSTVwcEEcr+MMG7USDik4Uy8kNuz6amTzAZ9L73Eo9g7uyrGQFjOmZAsQ8W2jbfWE0j/vCOGS7E/CxhILfBe0z0TasL3g+N0k0hAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771251918; c=relaxed/simple;
	bh=kCGqJIaDX5f6yv6thjxkoZ3TawsKPgZ0E8IC+FDXC/s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p6qHhm+2pgLBalEl51YEpr4mIzjUOTW6MNAnNHnv06rJfXJ+UUATc4/1wLYnmP/NLX7PYUucuSkiJwQ+cpFZ3deunkq88rf+vptlUNeYNq/RwSQ0QYa0mHZG0Nh9mB9tZII994h2cDmpu3w/37N2rP9px/2/u4cUgmyIXO84auE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=th7wjGTX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="th7wjGTX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCA21C116C6;
	Mon, 16 Feb 2026 14:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771251918;
	bh=kCGqJIaDX5f6yv6thjxkoZ3TawsKPgZ0E8IC+FDXC/s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=th7wjGTXhr5+033pNx2RNmqJOLEwrDpNHhH1xpvmxoIOtpbE5xKkvTy7mepwc3dF6
	 S10itHpIrMEe1Z/gww83Hw5Mb4Yjb58gmZqfx03wRUX3efqs+FxtIEoy/ho4/kkFp4
	 XWafKuyReQvzDqlRzl9fzeMo9gxUEblLS4V1u9dw2af6zU9LJHDYXrv5NB0UdBYye7
	 B7rhgBV1BIuhG00cuZkCb6iJs2HYgfGgMD96ObgR/RbAHbagGHkREfdCyAtztNrRch
	 KpZHhaq1KUGkRG0pEFSFKHtDiokVYiTXwW0AOwP8rtBnG0FN0tkBVhR4gnjfBIr74Z
	 M5Ar+FD9JGQsQ==
Date: Mon, 16 Feb 2026 15:25:13 +0100
From: Christian Brauner <brauner@kernel.org>
To: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-block@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-nvme@lists.infradead.org, bpf@vger.kernel.org
Cc: lsf-pc@lists.linux-foundation.org, linux-kernel@vger.kernel.org, 
	lwn@lwn.net
Subject: Re: LSF/MM/BPF: 2026: Call for Proposals
Message-ID: <20260216-ruhelosigkeit-umlegen-548e2a107686@brauner>
References: <20260110-lsfmm-2026-cfp-ae970765d60e@brauner>
 <20260119-bagger-desaster-e11c27458c49@brauner>
 <20260129-beidseitig-unwohl-9ae543e9f9f5@brauner>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260129-beidseitig-unwohl-9ae543e9f9f5@brauner>

On Thu, Jan 29, 2026 at 05:13:52PM +0100, Christian Brauner wrote:
> On Mon, Jan 19, 2026 at 03:26:39PM +0100, Christian Brauner wrote:
> > > (1) Fill out the following Google form to request attendance and
> > >     suggest any topics for discussion:
> > > 
> > >           https://forms.gle/hUgiEksr8CA1migCA
> > > 
> > >     If advance notice is required for visa applications, please point
> > >     that out in your proposal or request to attend, and submit the topic
> > >     as soon as possible.

This is (likely) the final reminder to put in your invitation request!
The invitation request form closes this Friday, 20th February.

Fever has struck me down so all you get is a bad limerick:

There's a conference called LSFMM,
Where maintainers debate and condemn,
They argue till dawn
What's merged or withdrawn,
Then next year do it over again!

Don't forget to pester^wask^wremind your respective organizations to
sponsor LSF/MM/BPF 2026! If it helps, you can tell them that we're
considering renaming it LSF/MM/BPF/AI.

Thanks!
Christian
