Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B58D02C159F
	for <linux-scsi@vger.kernel.org>; Tue, 22 Jul 2025 08:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753172355; cv=none; b=WiG3r/2vf4nmYsPFOMQe7aX8eZaesoHwN23JXE1Eit91F9+++saMxE9GMAFTBDqOBNHCc3ezwd1XUQMKFA7slnXBA4r0IEJM6ob+DNTS3wrr6YMAcVOgkMES16qH2jcV1TBsRZ7+xq4tNvHLFI9PbSIcLUUOl258YK0tfMLrGaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753172355; c=relaxed/simple;
	bh=2np78owCtY0zXiGio/2IvH6pWtbfqh7vq32px6BlLpI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=Nlwi18UlT2S1Uq4Vqq55EV7cra5Y8MYj9Ybeypjxtq5/Zsxq4tg0Dp+FG7VpF/OYBDDINCmWeOuhtmUylTFQMpQFpKviqPOA5zHIh4yGhAWRgTzOjTMiw0ZwUC+Tlul+JzgUPbpUL1Rs4tp8v19NnH0azvPA4x+hqWEPVvObJiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=mTIn/bwS; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="mTIn/bwS"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20250722081911epoutp034ff12aea1c13c546edcc872f6022fd4f~UhPbxv-fO2655226552epoutp03A
	for <linux-scsi@vger.kernel.org>; Tue, 22 Jul 2025 08:19:11 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20250722081911epoutp034ff12aea1c13c546edcc872f6022fd4f~UhPbxv-fO2655226552epoutp03A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1753172351;
	bh=AxUcsZm5yZiXaI15ZeDb0qU35ud3so0yBE1NGQ4Ni+U=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=mTIn/bwSlLWIwrUN5ufEHb0NRKcXvjBKHPRzPYXNYNzoUjm2fEPF88YQIsj/MRSBk
	 mtzPEgapuDCYAWsto1mGPtHk1JKXnMLjmSI5PDNt2Sxh+wcNPmNce+RB5Ht8d8iIKm
	 l1VbUPQFzrNZy7Ptpvk40sZkzLl9l/Dhg6CqPGOo=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20250722081910epcas5p442aa60e9967bf401c7041948a9ef0f58~UhPbKjWI00169401694epcas5p4A;
	Tue, 22 Jul 2025 08:19:10 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.91]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4bmVXs4xG9z3hhT3; Tue, 22 Jul
	2025 08:19:09 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20250722081729epcas5p12dc547bda002c28435d83dc7e972c105~UhN86SA4s1721417214epcas5p1z;
	Tue, 22 Jul 2025 08:17:29 +0000 (GMT)
Received: from [107.122.10.194] (unknown [107.122.10.194]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250722081727epsmtip1d6ed31e2cf992237114606f812d63623~UhN636tdp2238122381epsmtip1Z;
	Tue, 22 Jul 2025 08:17:26 +0000 (GMT)
Message-ID: <8072a659-0cab-43fc-bff7-618942346646@samsung.com>
Date: Tue, 22 Jul 2025 13:47:22 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH for-next v5 0/4] add ioctl to query metadata and
 protection info capabilities
To: Christoph Hellwig <hch@infradead.org>
Cc: vincent.fu@samsung.com, jack@suse.cz, anuj1072538@gmail.com,
	axboe@kernel.dk, viro@zeniv.linux.org.uk, brauner@kernel.org,
	martin.petersen@oracle.com, ebiggers@kernel.org, adilger@dilger.ca,
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	joshi.k@samsung.com, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, gost.dev@samsung.com
Content-Language: en-US
From: Anuj Gupta/Anuj Gupta <anuj20.g@samsung.com>
In-Reply-To: <aH8xY3PyejzGdUp7@infradead.org>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20250722081729epcas5p12dc547bda002c28435d83dc7e972c105
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250630090606epcas5p42edec1dfe34f53c9f1448acb0964bb8f
References: <CGME20250630090606epcas5p42edec1dfe34f53c9f1448acb0964bb8f@epcas5p4.samsung.com>
	<20250630090548.3317-1-anuj20.g@samsung.com>
	<aH8xY3PyejzGdUp7@infradead.org>

On 7/22/2025 12:06 PM, Christoph Hellwig wrote:
> What's the status of the fio patches to support PI now that this
> has landed?
> 
Hi Christoph,
Vincent and I have been working on the corresponding fio support - its
nearly ready. We plan to post the patches soon. ITMT, here's the WIP
branch for reference:
https://github.com/vincentkfu/fio/tree/pi-block

