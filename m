Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7107A353A79
	for <linux-scsi@vger.kernel.org>; Thu,  3 Sep 2026 06:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788415271; cv=none; b=fpg0Rn4GUpAqxrow5hZRPSNN9aGrV9o5FEV6eM4C7ak3rzXLOufCgxNBNqYfgiHFYmBudE8bUghbj7vVH1I1l+lACIKsquz+0IDPrM8kzCvlDUiFqvYh2n1sxBe5MYHuFPfiJPdO9vIxcigMTNOdb9uXQcjmo0BHL08NPT1xeHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788415271; c=relaxed/simple;
	bh=0F0/wppzj8EZN/czrkFmVD6Pits/wZzDSbvylgHb7Ug=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=ie6XckAxY4VtHjRHG+JKCIzP0TQAgWRnTW8FPwjJenKDz/JAqGhEMkpdCcvAq4iv2LGZfoWryqM/wp0/Zl6a/Vb+SJFGZzjhZYWX3ELtxlNBiALhHGqBHL0n4HVGqmSGfIcRFy5aghG9P7BJd0wwR1vV/Pe2IvezLorYOBBQ0Og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=hbyVyYHV; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="hbyVyYHV"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20260903060107epoutp04196bafcf08a7a20bc35f0c78b7c8a655~RujXqwq6d2897428974epoutp04x
	for <linux-scsi@vger.kernel.org>; Thu,  3 Sep 2026 06:01:07 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20260903060107epoutp04196bafcf08a7a20bc35f0c78b7c8a655~RujXqwq6d2897428974epoutp04x
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1788415267;
	bh=0F0/wppzj8EZN/czrkFmVD6Pits/wZzDSbvylgHb7Ug=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=hbyVyYHVZjbDmzDOkhaji0d5X3oHZ1unVa9D27/FrvtzyVX/ouEuU9Z3DIDKgMxmh
	 gPYDNIqqGDY8fsw/c5XkNU8jHZTpHpezI9mSYZoYjRdJVpUggpSPOBTNYuPLU70qTH
	 AvaQsDV6KIsxNobPOkcDOArSc7H52EKFvYtYSKR4=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20260903060107epcas5p22b92740d247d2ca79a6d1cd874be7c57~RujXYBVXl0234402344epcas5p2p;
	Thu,  3 Sep 2026 06:01:07 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.91]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4hb89H02XFz2SSKx; Thu,  3 Sep
	2026 06:01:07 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20260903060106epcas5p38d772562bb61a8a9f3a9748397ef4f79~RujWgBAX71210512105epcas5p31;
	Thu,  3 Sep 2026 06:01:06 +0000 (GMT)
Received: from [107.122.10.194] (unknown [107.122.10.194]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260903060105epsmtip18afba9371c5c482a8daba7bcbcf863b3~RujVaS5vL2830128301epsmtip1Z;
	Thu,  3 Sep 2026 06:01:05 +0000 (GMT)
Message-ID: <670be9cf-e6e9-436e-ac7b-f2c759c1ceac@samsung.com>
Date: Thu, 3 Sep 2026 11:31:04 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/6] generic: test I/O on devices with T10 protection
 information
To: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@kernel.org>
Cc: fstests@vger.kernel.org, "Martin K. Petersen"
	<martin.petersen@oracle.com>, Kanchan Joshi <joshi.k@samsung.com>, John
	Garry <john.g.garry@oracle.com>, "Darrick J. Wong" <djwong@kernel.org>,
	linux-scsi@vger.kernel.org
Content-Language: en-US
From: Anuj Gupta/Anuj Gupta <anuj20.g@samsung.com>
In-Reply-To: <20260831064557.2577241-6-hch@lst.de>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20260903060106epcas5p38d772562bb61a8a9f3a9748397ef4f79
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260831064632epcas5p179755b26ebfe06406a7b640cb1fa8a3b
References: <20260831064557.2577241-1-hch@lst.de>
	<CGME20260831064632epcas5p179755b26ebfe06406a7b640cb1fa8a3b@epcas5p1.samsung.com>
	<20260831064557.2577241-6-hch@lst.de>

On 8/31/2026 12:15 PM, Christoph Hellwig wrote:
> +#
> +# Basix FSX sanity check when using T10 protection information
> +#
s/Basix/Basic
