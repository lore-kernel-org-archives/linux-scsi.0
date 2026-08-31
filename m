Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7EFE3B8D75;
	Mon, 31 Aug 2026 09:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788167648; cv=none; b=Juzzgo1DI2TqvR+avz0nlpOPu1/Id8e0Ht83zhIpBCnFssIorI2OCwhDmuvpICRBLUQBNm8ezJmtkyYwJVUGmX/JpUT1mtqnflonjQzLVTc8EMtUra/KFp2GYNeiuhPc4t+GYxgIzg5qrUYrPFuULIDSYF1idcq8yCEfSkeGwX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788167648; c=relaxed/simple;
	bh=EW6uPQKhyPVPqKYJ1BmDiJPAOLmyVyXVtBgh0OfjcmE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mQemuk8+W0qKLdnglbTtIxIu6FiKLGK5oEMCpMvLwrvnjsoXOnZLIIRcBPOM70iPD0pnuBHeeN9bbafgC8uN+5S9x1tpTmF5Zru/F14mQpi++EO/z3/yBF9fbXQCcfjnaB6lmZhHcjo9G4zQloyV/igvoKWt9rU9larBVm5Tg7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=keTt8mj7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="keTt8mj7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECD841F000E9;
	Mon, 31 Aug 2026 09:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788167647;
	bh=EW6uPQKhyPVPqKYJ1BmDiJPAOLmyVyXVtBgh0OfjcmE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=keTt8mj7TakpGUXAPdmAUocNMX0OIOBWx7bLyOLGQORgDmWNXYCzKuLtZz05lDWs2
	 KVpKt3ZZYNqEn+Ce0U5qEYUqIv8pxDkRPfvFT6OYXK7A9DE8WjNu6+1fJK2sSI5VRq
	 cQPD0l9eAtdyuucxi/3mn3KqsJVrYQaLCEiiXkrUvVqP6dqv2T4VKXkdrnOM+yye8U
	 1trfZ2j8e0wBzLCDouA45wIlRHDqpLAjySFVRRAq/q/NRrr4EmMLrSDcpSam6Vr57T
	 cuWpxqLGdbNHI66duwZkJ7dc11ytu+I6l2pm5gNLlqlreYYwDbHng8DoHoNn9Zndwk
	 jM1iPyMnPvnMA==
Date: Mon, 31 Aug 2026 11:14:03 +0200
From: Niklas Cassel <cassel@kernel.org>
To: Phil Pemberton <philpem@philpem.me.uk>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org, Damien Le Moal <dlemoal@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v8 0/6] libata-scsi: multi-LUN ATAPI device support
Message-ID: <apVF22SjDzqkzEkm@ryzen>
References: <20260731213503.2379771-1-philpem@philpem.me.uk>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260731213503.2379771-1-philpem@philpem.me.uk>

On Fri, Jul 31, 2026 at 10:34:57PM +0100, Phil Pemberton wrote:

(snip)

Hello Phil,


There are quite a few comments from Sashiko both on v7 and v8
(which is just v7 rebased).

Note that Sashiko's output is probabilistic: it might find or not find bugs
(or find other bugs) with the same input.

So please look at both the comments on v7 and on v8.
You don't need to fix all pre-existing issues, but we would prefer to not
introduce new issues that have been flagged by Sashiko (unless they are
false positives).


Kind regards,
Niklas
