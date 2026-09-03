Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43A1836A34F
	for <linux-scsi@vger.kernel.org>; Thu,  3 Sep 2026 06:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788415236; cv=none; b=DRxdefkcWu4cXJSuShpne8fcNGdCcAmJPpflQk6SWS+tKRjVcbKlZ2xXmKEh2r9esXUGVON7DJNuPPDMi8aPPd3cBHwTfHsoOv78I8w7TILfCL8oG7hMhdVzf2HhPQSKeUtpm2ACjWnS9ReRqc2WZq2iQdunPWPrc7u75Rx7jHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788415236; c=relaxed/simple;
	bh=VsEfpPZ4/b4kXA4LsfpmnJHSUwBg64hOprneQNKW0oo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=krzVcacZpEajCXvkYqbdbZvSIXMKxbEoQS8+MYLWtLKOlJJtJw3zIOqL6aDz71fdiX9TnGM3AAXzBozP+GqZK7Hz5Sa6Abf2BUTKGraSDwC0Waa6B3kMMnGN22mXCr8k8uIuJjeTV/BrpBH3oFHd51Ab1xknyatGjCPKpUCr+tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=EhzwQ7vb; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="EhzwQ7vb"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20260903060030epoutp014b4ab416a6a4dbf98c0d8239b80a9ad0~Rui1NM1HV0508505085epoutp01U
	for <linux-scsi@vger.kernel.org>; Thu,  3 Sep 2026 06:00:30 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20260903060030epoutp014b4ab416a6a4dbf98c0d8239b80a9ad0~Rui1NM1HV0508505085epoutp01U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1788415230;
	bh=CQLF7lkwZ6iJ6VTo6wQxUqOuNb/vCXMKNNFvRIa+QDg=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=EhzwQ7vb98sJLaNZOIJHaY1eMKzBmVeccTAaPPvyTm36lqNu1c5UBjYqaBh/K4+oT
	 FWjJXdjF+pZc2a4BzdasBg3pl/MCt9KRQV3jY+E9SgFeR7qwCdA7QODfZ0hXuaSm8M
	 0LaUOVdNc+ndT1kfK57m5pZP5/W1DxqYwDk4HDuw=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20260903060030epcas5p2c3562afa0da40b6ed4c24af1f8213a46~Rui0ol2Ah1589115891epcas5p22;
	Thu,  3 Sep 2026 06:00:30 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.90]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4hb88Y2sSsz6B9mQ; Thu,  3 Sep
	2026 06:00:29 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20260903060028epcas5p4e38b04cbaf4bf1512cb983ea4a1edc29~RuizftUua2593025930epcas5p4a;
	Thu,  3 Sep 2026 06:00:28 +0000 (GMT)
Received: from [107.122.10.194] (unknown [107.122.10.194]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260903060027epsmtip1e07751727b9b4f417f07fab44cefc70f~RuiyZ9ovY2694126941epsmtip1f;
	Thu,  3 Sep 2026 06:00:27 +0000 (GMT)
Message-ID: <93041ae8-da31-4482-b12c-04750629f475@samsung.com>
Date: Thu, 3 Sep 2026 11:30:26 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/6] generic: test corruption detection using T10
 protection information
To: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@kernel.org>
Cc: fstests@vger.kernel.org, "Martin K. Petersen"
	<martin.petersen@oracle.com>, Kanchan Joshi <joshi.k@samsung.com>, John
	Garry <john.g.garry@oracle.com>, "Darrick J. Wong" <djwong@kernel.org>,
	linux-scsi@vger.kernel.org
Content-Language: en-US
From: Anuj Gupta/Anuj Gupta <anuj20.g@samsung.com>
In-Reply-To: <20260831064557.2577241-7-hch@lst.de>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20260903060028epcas5p4e38b04cbaf4bf1512cb983ea4a1edc29
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260831064639epcas5p4e02eef8306da9865f278d578a6ea8dd9
References: <20260831064557.2577241-1-hch@lst.de>
	<CGME20260831064639epcas5p4e02eef8306da9865f278d578a6ea8dd9@epcas5p4.samsung.com>
	<20260831064557.2577241-7-hch@lst.de>

> +	if [ "$last" -eq 1 ]; then
> +		echo "adding to $phys_blk" >> $seqres.full
> +		phys_blk=$((phys_blk + 127))

last sector for a 4096-byte block size would be 1023 not 127 right? 
maybe use something like this to calculate the last sector?

phys_blk=$((phys_blk + (128 * blksz / 512) - 1))

and maybe rename it to phys_sector

> +# Note: Type 3 doesn't have a refrag, so don't test it
s/refrag/reftag
