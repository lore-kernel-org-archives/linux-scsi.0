Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792811136;
	b=O20kgCzqodXq/6b6d7FpMd5ftAX3fRcItv4a+PoErZ8Tt3/+FfVdV6s2cxD1ZydFiX37
	 n1qqO+eZurhe7c/nIL/YWfzsmFV0gVU+4HBvfeLST8r/IEFpD49gfoCzgbNzJJgLcx7by
	 qAAMzmAeL7RZc1mB60WiqC8YItxIYS5x5PK4WYyQDtF/nx6UV+arDtSGsDoZDZ4PCJTmd
	 ixEbzrCJNGSD/WAYHF3M9dXxC6VqT9j6BKsOR+saPQ2QRzUT4uaKjrFpI7Tnl67tDRHXL
	 eKGwBuN7y0SkXcfzEJwVC8zGuSCj5AlwmGF9eelLxaaJ54LH0lS8+u5Nh/CVKROL8hA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792811136;
	h=Received:DKIM-Signature:To:Cc:Subject:From:In-Reply-To:Message-ID:
	 References:Date:MIME-Version:Content-Type;
	bh=sXlexXVyaZs4n+IvAt4+Ql/FTWVNz5R/wfmg+BBxB90=;
	b=WRcEws8pB8vjP10ILtghHMr4iISGaR9rKOC05gC/vTocDNs0odDTPhdYG42tYMhMg7pn
	 hO3iULT8PXNqm/NzFbFs9Cr2NP1OXc1XfMjPul/CfHfmns6kiRy2s5A55QXLqcUD7X8/4
	 TwUQNjzKkvYFWUj0i8uvgFto75HG2lJPLlLRebX7XTpR2/fSB7o7GiGkIKdBLFlMjxwf9
	 gLm5QNkpDgiVwgbuxKqUofKn00ShAp4yhBjWlZdvjDQjHMyLfq8t2pJ+HDUxeAPObXM7q
	 X2kbn+3ZlZHAZO9uAe6vC1qX7rww3vZh3PPTFETmsjowmmNP01BYIuK308OMGan47EA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jv7945fz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B901606A31D
	for <linux-scsi@vger.kernel.org>; Sat, 24 Oct 2026 03:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jv7945fz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F3E21F01825;
	Sat, 24 Oct 2026 03:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792811136;
	bh=sXlexXVyaZs4n+IvAt4+Ql/FTWVNz5R/wfmg+BBxB90=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=jv7945fzPqFwyzYGh7SHaUGBUmZia3/WrHQe5uEF0Bt6eX8JN5+zPaM0ybXtWHtRc
	 vzMlApU7tmLja1kwyN4J4qkCRWI7s8CI2GgwQlyFexHRM62acfmG7FzcLmka0cgsJE
	 xGr8k7lcnPWVlQSCeJPqDoxRAMxv02y0ZQ3VEWy/uIJlQ3MlDL0nO8PAmGR0ETk5Tt
	 u0ESk0J5bwujcTMhtHPJkNfXkcsLeKZimk61i35MMv9ba3PWeHSf/LahocWf/BjfIZ
	 3m4mX7CdMCdXAPlp38hkFi/CCF+DreFc984a0zXM/T30Aj2kPm/wRhkDQ13ROQHP3l
	 09hLvkeVQQPAA==
To: Nilesh Javali <njavali@marvell.com>
Cc: <martin.petersen@oracle.com>,  <linux-scsi@vger.kernel.org>,
  <jmeneghi@redhat.com>,  <GR-ETH-Storage-Upstream@marvell.com>
Subject: Re: [PATCH] MAINTAINERS: Update Marvell Ethernet storage maintainers
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <20261023085112.1378540-1-njavali@marvell.com>
Message-ID: <yq1wlr77q88.fsf@mail.kernel.org>
References: <20261023085112.1378540-1-njavali@marvell.com>
Date: Fri, 23 Oct 2026 23:05:34 -0400
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain


Nilesh,

> Add Nilesh Javali and Manish Rangankar as co-maintainers for bnx2fc
> and qedf. Also update email alias for bnx2fc, bnx2i, qedf and qedi.

Applied to 7.4/scsi-staging, thanks!

-- 
Martin K. Petersen
