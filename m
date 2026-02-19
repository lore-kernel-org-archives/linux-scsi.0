Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F2D23EBF2E;
	Thu, 19 Feb 2026 00:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771460776; cv=none; b=D/3zT2exQs3PIFtTmL45OPGup3pvAEG9DEWu9kGf1rW2utpyDi7c6hiR+sc1jj+wKQApjUSMY99nyyUJuj2Tdw0xYnnduCAPGWxdqdShiVRsI05wkZ7kgAsN3lbfSR2+NM7hrdEejHWXN8SHDxYsOBPEzF/OhI4qNFU+3z7DyOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771460776; c=relaxed/simple;
	bh=Y1VUzMYKJDjgFUQ3wVOPgQU63jZVKJBlr6oc8WI+E5c=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OvI1LNPG0s1SJ+vzMLBy6fzgSyU4EHs2aRtzjB5DzfYhWXwO1SqGH+4+gdUOD2R4KWoCNCHdw6zfH9PcFY+M5ISuG+hBdpoM/lTd7dkZZil6dbdGbSjO8F2DxSbXvMlQ8p5c3JmbADAg4HXJMK38V3MBykFjAodROvDHE/jsG/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V40kfbcm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V40kfbcm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34496C116D0;
	Thu, 19 Feb 2026 00:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771460775;
	bh=Y1VUzMYKJDjgFUQ3wVOPgQU63jZVKJBlr6oc8WI+E5c=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=V40kfbcmMkKV1sqVv9HEUtEVV/FOX6e4CXhZJ1pnPZw+dcTMhwNHsEZPDIIswzL/2
	 43fu6Wm9IFRykRmGcLhuJU4k/jOTF3Ea+5q4J2Pemio96wc815odedUnHe8fSgokFh
	 zMXe0CfrSh2zqxca5ezs+T2xSu3fDUOn8A7r7NCRG6sQiHokeh0cNNvK+NXL1fQ331
	 0Hc460EnKsc6gHOpRzLVw+lSifseCwd9IaveMqxqys1FNj/1Hg8Xk/fTWYWXA0dtw/
	 10kmlItuN4VW8IP6fvvuWVJ69Jc36mhP1PsUKWOm76TurBqEyx3v1o7Ov4qSY2BS7K
	 +rAL5/pwi5c5A==
Date: Wed, 18 Feb 2026 16:26:14 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Juergen Gross <jgross@suse.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
 linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org, Stefano Stabellini
 <sstabellini@kernel.org>, Oleksandr Tyshchenko
 <oleksandr_tyshchenko@epam.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Bjorn Helgaas
 <bhelgaas@google.com>, "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"
 <martin.petersen@oracle.com>, xen-devel@lists.xenproject.org, Marek
 =?UTF-8?B?TWFyY3p5a293c2tpLUfDs3JlY2tp?= <marmarek@invisiblethingslab.com>
Subject: Re: [PATCH v2 1/2] xenbus: add xenbus_device parameter to
 xenbus_read_driver_state()
Message-ID: <20260218162614.09b8c41b@kernel.org>
In-Reply-To: <20260218095205.453657-2-jgross@suse.com>
References: <20260218095205.453657-1-jgross@suse.com>
	<20260218095205.453657-2-jgross@suse.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 18 Feb 2026 10:52:04 +0100 Juergen Gross wrote:
>  drivers/net/xen-netfront.c                 | 34 +++++++++++-----------

Acked-by: Jakub Kicinski <kuba@kernel.org>
-- 
pw-bot: nap
