Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=82.195.75.108
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793104456;
	b=SRQjqEsBk6I7qrTYYNfXy9ogA4ztyQZJAnPmiJVU/Tl9EyKdg3VrHSNuhm5SgnxnaIH5
	 pgldVdiaK7eFvsnPVFCOntIh0vUsYQqxftdr10Z96loyomkqzMOFdE9rwacSGNP6ygak0
	 9/SkKc0ZUk0tKMOkMlWUCi04m4jIyvENdfxQTYJ4xqw64e9hPtB0L4JLn30v2xgqu924L
	 gWtniH4cN51FUthT+WBQwkJqzMaPIzlzWW/SX7PHlMW96E2Bn8wKKAjRGkmMVvgEGBr6M
	 TJ07gjpva+omx4yGR9pK70P+75t7VUAfKt4GMUHcicIiwfdfH7i8Sp/vkV3nbTMwTtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793104456;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Debian-User;
	bh=uNS2L2iMcOC4fIL5rjAO/7Q+oRPwueCBxvTT1iYaWfQ=;
	b=3j7NN+XPDKYYNFkdCjenZgtMDA68Xc6LBuzE8SDbrrlQ/bj0BMhmenpIEwplcFki5fnl
	 i5wcZsqcN+Fa8fSW2PMpeaTrGvKTdcoTlrIqvNjugBoXfDcgEw5l86MiL3pUU/1BHl/5y
	 QUuoe3tQA9PySPQcj36DmW/F/2lsKV0iZoy7Rq1Avi07Y5j3uIXK1y9K95xVTd3GHCbOo
	 uq+1EtHJcW/6ArsAw4vdV7924wXFgKuKCimjhRUro9De52WQWL+YtfRHjrtVDvwK7TzyS
	 CDX53bCP/Mh0DO2EgNsNRsZoCNZ4G2/xkjDzCG/oGReBma2XEHxshch2OYGxAQOpbkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=debian.org;
	spf=pass smtp.mailfrom=debian.org;
	dkim=pass header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=JtnOwapk;
	arc=none smtp.remote-ip=82.195.75.108
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C53FD606A31B;
	Tue, 27 Oct 2026 12:34:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C53FD606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=JtnOwapk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=uNS2L2iMcOC4fIL5rjAO/7Q+oRPwueCBxvTT1iYaWfQ=; b=JtnOwapkIsOlSiyUSlZyh6cLaG
	/VAvWk6wCuoGnUETa+XAr8pm/tUWPxsvxHqebStP9cpYAEVNiIO8IRSvRKkYGzWOnB3Yt5WYA7iX7
	8iw1/DwO/cSkLh5VWQyx/TVVLrDRSOyBx9D3aV/Yw95N6ag6+OElf+ZgLNZADytLLCFMkZq4/9vgR
	FMwT8/nAwQ6EdlqWl+VZWuq0QZ6Ztus7t4CNCwAGso0g9fPqNP/5hKVFe0jp+Ag42JuT2iv8Dsvot
	zbBlP++l5O068pHS60pB0AfPP26/nr8y/w1Nky1fFuBabarsColjBKLAaOP+dlDaP0AGK7QImTPcI
	9mNc5a2g==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1xLgN8-001SUN-2W;
	Tue, 27 Oct 2026 12:33:46 +0000
Date: Tue, 27 Oct 2026 05:33:41 -0700
From: Breno Leitao <leitao@debian.org>
To: Runyu Xiao <runyu.xiao@seu.edu.cn>
Cc: Christoph Hellwig <hch@lst.de>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Sagi Grimberg <sagi@grimberg.me>, 
	Chaitanya Kulkarni <kch@nvidia.com>, Keith Busch <kbusch@kernel.org>, 
	Logan Gunthorpe <logang@deltatee.com>, "Martin K . Petersen" <mkp@kernel.org>, 
	Lee Duncan <lduncan@suse.com>, Hannes Reinecke <hare@suse.com>, 
	Nicholas Bellinger <nab@linux-iscsi.org>, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, 
	target-devel@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
	Jianhao Xu <jianhao.xu@seu.edu.cn>
Subject: Re: [PATCH v7 1/4] fs: configfs: add helpers for opening
 non-configfs paths
Message-ID: <auCZ-EdCKGup3a-W@gmail.com>
References: <20260927082011.638723-1-runyu.xiao@seu.edu.cn>
 <20260927082011.638723-2-runyu.xiao@seu.edu.cn>
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
Content-Disposition: inline
In-Reply-To: <20260927082011.638723-2-runyu.xiao@seu.edu.cn>
X-Debian-User: leitao

On Sun, Sep 27, 2026 at 04:20:08PM +0800, Runyu Xiao wrote:
> Configfs store callbacks hold frag_sem while they run.  Reopening a path
> that resolves to configfs from such a callback can acquire the same
> non-recursive semaphore again.
> 
> Add configfs_file_open() for configured pathnames and configfs_open_root()
> for paths relative to a resolved root.  Reject configfs roots before using
> file_open_root() so the normal open checks remain in place.
> 
> Assisted-by: LLM Codex
> Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>

Acked-by: Breno Leitao <leitao@debian.or>
