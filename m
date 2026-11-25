Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622562;
	b=OY8gmKvuDKpkRpf4GSc/5u/FjU+2WPtsXU7Z+OYn8UusaB+gWC0HQiA6ClLxT+T/SegL
	 yF0KxUc+tqBLbacsfWU4FosO0wwHYu0CYF3Jw3wLiJRVqLcTEye/CSBL2JhrKZZuVyPfI
	 JkExQu0t5FdEfLMaVJlF8vaAHDdyPvUEGQR4sGFMOTMhue9usLl2VQfh+pQ9QgBNfDy11
	 nnLREj22IR8gWcTcOuhe8VuqIAfIKgG82HHgXIK5GlcjJT3UAvH5sYMMqeLeIHP/7mLFO
	 D/pXT6sLgDjQeALuaoQYNHdTVVd5SO8aESbDq/td/DHpj066MNv28GVlScE5ByILiHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622562;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=2pLlpYDpA//PFP4JeljNFmIdGPmvmYjcAuyjA0H+4WY=;
	b=fduNHc00AQUMhhVathy/xJMmTsX9mV9rLqULhF2jD7jBLBOljiKHUEfZ6SXXx2ffgZFH
	 F+VrVhZLgU+rdMo/pyqQmiWd694TAQHAgvCRXBZFPxc9LJJVmlxGAqEdwXFKwiKdH5bxb
	 JZkFcR6S8IO/d6nYA6ZKZ7xNuAurma4Fn9uZk51L+5WahPrLyHT0DauAJhFF8P4t27ZdW
	 KEkJqCRU77hkVB/cYhwq4I7B+6AIADV23LUmilnXV4zvcFMLF1UgwncSuz01e/LUJDjeS
	 0ynjtI7IB4QpepPmQdG/msJMu5q+LabDw5yewjNkjO0/K2DIskUFMcZdEaj00kti2Rg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=LCRgAWyl;
	arc=none smtp.remote-ip=199.89.1.16
Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C683606A31E;
	Wed, 25 Nov 2026 16:02:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9C683606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=LCRgAWyl
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4jZPb41GG5zllCWB;
	Wed, 25 Nov 2026 16:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1795622557; x=1798214558; bh=2pLlpYDpA//PFP4JeljNFmId
	GPmvmYjcAuyjA0H+4WY=; b=LCRgAWylv12A+5FUpV9kN9fYmKO6uvo/JWxDp6uV
	fWJna/WbtRXi7Aa1N/fciOogZpvaP/LlpNTegTb4O+FItkbRxF1oHJto+7DCTK2M
	Xe4HBKlBL7PU0ER5tzDX3wG7vgGCTS0EofN1LnLU4twsPLTizYkI5zpZ9Lji0u8P
	QGlsL2lQjjuCFe9abvLKZV5rmhc5PKtDQ8A6S/i4rTnlOg9YWhgs5j+eeKyPwMmB
	SVAvu1l+dFY60aVFSmUkI886TwjuvYbwt2VAFlMr5mz2XsQJq6ZWlkO8aVh0o8y2
	q71CWF+zz2h92rAmAoU4HXQU1E75AWLZEv7SiB5sDyjqNw==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id x4zFz-Pys5p6; Wed, 25 Nov 2026 16:02:37 +0000 (UTC)
Received: from [192.168.0.215] (c-24-6-239-25.hsd1.ca.comcast.net [24.6.239.25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4jZPb11kj9zlqg7w;
	Wed, 25 Nov 2026 16:02:37 +0000 (UTC)
Message-ID: <7a2f05b3-eced-4ec1-96aa-41163b3ba8ca@acm.org>
Date: Wed, 25 Nov 2026 08:02:35 -0800
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/3] scsi: ufs: core: Add debugfs for PA TFS/FEC error
 counters
To: Po-Wen Kao <powenkao@google.com>, linux-scsi@vger.kernel.org
Cc: Konstantin Vyshetsky <vkon@google.com>,
 Randall Huang <huangrandall@google.com>,
 Alim Akhtar <alim.akhtar@samsung.com>, Bean Huo <beanhuo@micron.com>,
 Stanley Jhu <stanleyjhu@google.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <mkp@kernel.org>, Peter Wang
 <peter.wang@mediatek.com>, Can Guo <can.guo@oss.qualcomm.com>,
 linux-kernel@vger.kernel.org
References: <20261125113435.1426680-1-powenkao@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20261125113435.1426680-1-powenkao@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/25/26 3:33 AM, Po-Wen Kao wrote:
> This series exposes the MIPI UniPro v3.0 PA layer TFS/FEC error
> counters (0x15C3-0x15C7) under debugfs:
> 
>    /sys/kernel/debug/ufshcd/<dev>/pa_err_stats/{host,device}/

For the series:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
