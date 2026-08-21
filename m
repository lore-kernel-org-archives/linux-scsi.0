Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06CD72E6CAB;
	Fri, 21 Aug 2026 23:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787355042; cv=none; b=N3gHFBAL3gtmch9a4tr0M52b1LgLyL19IizzHnKDzrvJmKTIa58bH0MuYFTFZ4SKA3Zp5xNfoYj7SpnCMDmGGOn934qcF83iKd+Gfw1zSFAB+cOxxpMCM1hy7VwsxDRNjILLxoq4Nt1ZYIGtZAwkbNmLuvuCByD4Hr2fqOJ0l+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787355042; c=relaxed/simple;
	bh=C3ooQbRmDK7xyGhc/lV21mKyx5ZAC2CGimOeqQOnNuU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fm1XjKLkEXtCXWMMGfpIsv6LRZIetRT2scRpDw4jPAVW6mN0AO3Q9meF/d50/PIAkrTzputAV+Fu7+S1gf8u4oWshZnBQr5VMnO85NP7lLVyZOMKFuVWbkSumvl+90p1sn7+UMgvn7CZGHKoRDVeJauqP4E3++UhaTf/3IHCQZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U9kEAvRc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U9kEAvRc"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 79D5B1F000E9;
	Fri, 21 Aug 2026 23:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787355040;
	bh=lrM8RiozxDJIC3WFGUw6+mFIjzw53r4BzcJ677v6qfs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=U9kEAvRc80ITDNHPnNoK6m+j6IkP19JkUxDo6BVLl6tAUpOOwBEBz8SxieQ67umj0
	 22xjbk6ql6Kryg51AP9y3pryp4r+IT6KK//vTPQaAkdPRMXmbHJ3X5pznCgPsqxlef
	 NwRxcU/1Hn/bgzWugsCrOUzPpfyYwT+RNJ9Woiscq1r4S7L5lYSvbhgQOoEq2PwKX+
	 7XecIZzdREpoU4ZR0FWLDm9MxAAEOXODBzLaTvOwhPR4VnwkK5xoFWHhWC8m/orZAg
	 5JMkgJup0FAB8eKJnIIATjeHNsSQFjP7Gx4SB7tIJ/bqPpLSZCy3yJnP/X9ID2NgKa
	 vl6ytqOM0MCeg==
Date: Fri, 21 Aug 2026 16:30:40 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Anuj Gupta <anuj20.g@samsung.com>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 3/5] add a "pi" group
Message-ID: <20260821233040.GF839663@frogsfrogsfrogs>
References: <20260821051133.1817670-1-hch@lst.de>
 <20260821051133.1817670-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260821051133.1817670-4-hch@lst.de>

On Fri, Aug 21, 2026 at 07:11:28AM +0200, Christoph Hellwig wrote:
> Add a group for tests exercising T10 protection information.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  doc/group-names.txt | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/doc/group-names.txt b/doc/group-names.txt
> index 424e2c4a1ca6..ef6b8f51cf87 100644
> --- a/doc/group-names.txt
> +++ b/doc/group-names.txt
> @@ -137,6 +137,7 @@ tape			dump and restore with a tape
>  tempfsid		temporary fsid
>  thin			thin provisioning
>  trim			FITRIM ioctl
> +pi			Protection Information
>  udf			UDF functionality tests
>  union			tests from the unionmount test suite
>  unlink			O_TMPFILE unlinked files
> -- 
> 2.53.0
> 
> 
