Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E9DB8632B
	for <linux-scsi@vger.kernel.org>; Mon, 24 Aug 2026 01:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787536704; cv=none; b=CKxnRPfdBtHIvjXSjquwBOHrt88uaKgm4Tu4B3Xk7XnorCc1rPF+dpmQVnUwIWQd19bT8VUsrUAB7SWVKrZT+OKFVeSGsaK82eXHieQ6xi/5xCL+aEdLXeA0yt2VBd/KCcxplPN+y/Xn8z9iozo1xVmdUK9fqFRybyZdACP7dfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787536704; c=relaxed/simple;
	bh=ha8x/ywyveC7xbQ8nRZ7uTG2J07iNpRSkiCRDDPqKnQ=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 MIME-Version:Content-Type; b=l5vXUYdWYOygip5n046OtfF3EAedgLTuqshpDrG6bfXI6d+LK50BPUEu6pNUfkIWhKGzIcFmUBxnEhGQVel/lAhdX6BDN+sFTq+5m3+V756VUU3X7Ya/8XXNehuv7wDdv9e1lEqW6nEXsQV16rrgOcpWLDBmnvz42CV2Sl0oW0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aRjye+zG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aRjye+zG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D965E1F000E9;
	Mon, 24 Aug 2026 01:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787536703;
	bh=KeGH5JPrE5dObb0cgWjNMz+TvTWXWCKROWZb35fopDw=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=aRjye+zGsC+N5ly2oqisLWMmgi/kXLJnj0cylJ+nM8UyKPU02l+p8g0X/daqPz7Ia
	 52BgRx8hEH2xRLWRCZWSDnhpuddrqyn9wTtFOwpyPwL1Veo1zt1jkjBrlOQGGMF+xE
	 4DgzpykpGopLB6/p9rH2T6QLvoM1FCUdoAe5uAIzcTVpMr8Lpvex9UAo+4gnjUgAsr
	 EZRthEUYF67gyImUDitxZ5yUSX67aHsBpgW1qljMdVyPq6wG21z6EssVLOZEmwaOEZ
	 Dkpt6vgYdzDfvoLPAku/PnX9dNlAi46txSmR7T5wseXRewU3/6gOfKhsqLeRcb2nBw
	 fGE9YKbz5hDKw==
To: Dongdong Hao <doubled@leap-io-kernel.com>
Cc: <James.Bottomley@HansenPartnership.com>,  <martin.petersen@oracle.com>,
  <dlemoal@kernel.org>,  <hare@kernel.org>,  <hare@suse.de>,
  <yjzhang@leap-io-kernel.com>,  <kezijie@leap-io-kernel.com>,
  <jzzhang@leap-io-kernel.com>,  <baikefan@leap-io-kernel.com>,
  <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v2] scsi: leapraid: standardize NCQ priority sysfs
 attributes
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
In-Reply-To: <20260814090526.395704-1-doubled@leap-io-kernel.com> (Dongdong
	Hao's message of "Fri, 14 Aug 2026 17:05:26 +0800")
Message-ID: <yq1o6esnuts.fsf@mail.kernel.org>
References: <20260814090526.395704-1-doubled@leap-io-kernel.com>
Date: Sun, 23 Aug 2026 21:58:21 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


Dongdong,

> Replace the earlier LeapRAID ncq_cmd_prio_enable attribute with the
> standard sas_ncq_prio_supported and sas_ncq_prio_enable names
> documented in Documentation/ABI/testing/sysfs-block-device, and rename
> the per-device NCQ priority state to match.

Applied to 7.3/scsi-staging, thanks!

-- 
Martin K. Petersen
