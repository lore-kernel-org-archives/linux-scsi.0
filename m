Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6367469849;
	Wed,  5 Aug 2026 12:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785932476; cv=none; b=WFIauT8+Km+bjuTVzCkrqXeXC8UAZeD5uH461MS/afpybubr85VLfS9ciVHAI4v30tm2x/M8X/WXWOiUkk/SJ5SMzaKHbObOKEHrFcvg/0rAbBPZYHw9LNdV0quiHq5KGdwddaVzrJfGiZh0HkQziZ/0wdBvG0d3Ln8yhD1iT20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785932476; c=relaxed/simple;
	bh=IxnsFcaNSda5cJS+/IousFi7M+53W5tmgkmS0TzgyRE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cCe6Ou6HexaTvJpf110SaD21okmUXpEyZ2pCSU5YYIx5FOW+Wpz2KfVa37u9MYdQqMwnROXESJkuwQMFaGDI/D3/GpfjT8hZLVQgrQkBx471LS8CUsMUmpu9QqnpC3SX/d9ICY7pHcHxwEeUaQJ5V6N7lL3IrxlbWsGGVTRoxi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gk8cuYgD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gk8cuYgD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 568231F000E9;
	Wed,  5 Aug 2026 12:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785932475;
	bh=nObNpZnoOb1UU4Rco43T2RAIwx4R8yxofs7Fr4POBDk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gk8cuYgD3DdV9u/Ee1ff7h4ZpqtnLvUNTRS5Io+IxWChhpCJpoLjHvMfEJX7z/35H
	 uU2M4JIka1cVyribFGoz3eNaT76nPo8DNtqJykrw1aXe23IL+EdO2QqxzJNtuqsS4T
	 gU9wSR4BLeTyN6n5koHO+Kjrg1/QLNgUQFTcCB8TLfTzxbYLK5K7MdChT5RHGGWudt
	 j6e9YXmFo/pJbxNKPuIVvT3iKPqaj/emhbbAXDiI7+q9+GsH7SCiNY0TB+4PsrBjtg
	 sC8HJBwAKEF/ff/qCzbQArGs1J2DyhY3r1QvogDZAzXKhZYjJLTWGcYQAdCFdVAOa6
	 mEx8FS01URCGA==
Date: Wed, 5 Aug 2026 12:21:13 +0000
From: Yixun Lan <dlan@kernel.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: sashiko-reviews@lists.linux.dev, devicetree@vger.kernel.org,
	robh@kernel.org, linux-scsi@vger.kernel.org, conor+dt@kernel.org
Subject: Re: [PATCH v2 2/3] scsi: ufs: spacemit: k3: Add UFS Host Controller
 driver
Message-ID: <20260805122113-GKI77474@kernel.org>
References: <20260725-08-k3-ufs-support-v2-0-45036a2a2418@kernel.org>
 <20260725-08-k3-ufs-support-v2-2-45036a2a2418@kernel.org>
 <20260725104848.971611F000E9@smtp.kernel.org>
 <66c3cdc0-c3a4-4fd2-a25c-b71c98e525af@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <66c3cdc0-c3a4-4fd2-a25c-b71c98e525af@acm.org>

Hi Bart Van Assche,

On 10:27 Mon 27 Jul     , Bart Van Assche wrote:
> On 7/25/26 3:48 AM, sashiko-bot@kernel.org wrote:
> > Does using the bitwise OR operator here corrupt the error codes?
> 
> Please review the Sashiko feedback. I think at least the above is easy
> to address.
> 
Sure, I will address this one

-- 
Yixun Lan (dlan)
