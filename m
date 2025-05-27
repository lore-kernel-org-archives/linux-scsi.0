Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBF951465A5;
	Tue, 27 May 2025 21:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748381905; cv=none; b=YoZXF9WxKANj7FPjIDAWwnuHeMVqOHuyvkVY2y5ekqE0/Pf3xTvdkp2J5JjTOlIfsw6Fouz1cSSrmZNZ0UtXHzAkdM11kU6P0JoPLC0AJDBAlgq1pxTLVbTx9yHidi03hUAEu1vvyLRA10NVxamG38LUhuP13GCQY3eiq9rnYBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748381905; c=relaxed/simple;
	bh=oa4aau0o+QDBX1AUVYeSan9W4UogTjwV3ZMNtPcpQdM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JsMhuvlVzf1lHtGoQtJ9IMNFB/KoslPga4g4WG/mjvP4Wz6/dsYZo1onDEvbqTcozPpsxdi3rahz4pcJhqsf+ybQxBs3HpxYavHWSqEfyka/5/DpkPE1dkn6UkJsaqm6gX4BlElVGt9X/XW8kS1NZdQaa8KfnT6f4cfcWx5YkKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=DavGqlez; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="DavGqlez"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4b6Qwt4tJJzm0gbm;
	Tue, 27 May 2025 21:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1748381899; x=1750973900; bh=aLc5NxkI8M6spKxInjbGY5A5
	fJLpZLq+g1FMQFSSSOQ=; b=DavGqlezNjvN0lqUvuQ+5r9yVyOxdBlWx4RJtljG
	Aa3LRtX/nFT+4kSHpb31UMxnv3Wg4CevSpsUBs2/JanU4/RgZVN3uI2cSNU1tnXf
	Gl3kNcnVCDDR90xPK8JuVFcgkALf8G9Qo4w8xXLWbngogLlSTROy/ceMdWrsTLcI
	+MoVqXKgUU/22UHcDioPxN5TWG0fZeXgSlfsmv6lNwbXkq7f2ShIr20r7TJ1cWk5
	bjv94mDQZUnOf5U6TDijYfXyOlTDbB0fK4B73rLd3cf8gCfAOAaWqX99XAJcNKE9
	asqL9iKAYIRbn6O4EeiX4sqXekk6RPJQZ0u/XWbjH9mbdw==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id hhLAYRg3fNIf; Tue, 27 May 2025 21:38:19 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4b6QwV5NwCzm0gc0;
	Tue, 27 May 2025 21:38:01 +0000 (UTC)
Message-ID: <ae392b24-9096-45d4-a138-a6fb64dffaec@acm.org>
Date: Tue, 27 May 2025 14:38:00 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6] ufs: core: Add HID support
To: Huan Tang <tanghuan@vivo.com>, alim.akhtar@samsung.com,
 avri.altman@wdc.com, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com, matthias.bgg@gmail.com,
 angelogioacchino.delregno@collabora.com, beanhuo@micron.com,
 peter.wang@mediatek.com, quic_nguyenb@quicinc.com,
 quic_ziqichen@quicinc.com, keosung.park@samsung.com,
 viro@zeniv.linux.org.uk, gwendal@chromium.org,
 manivannan.sadhasivam@linaro.org, linux-kernel@vger.kernel.org,
 linux-scsi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-mediatek@lists.infradead.org
Cc: opensource.kernel@vivo.com, Wenxing Cheng <wenxing.cheng@vivo.com>,
 Bean Huo <huobean@gmail.com>
References: <20250523064604.800-1-tanghuan@vivo.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250523064604.800-1-tanghuan@vivo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/22/25 11:46 PM, Huan Tang wrote:
> Follow JESD220G, support HID(Host Initiated Defragmentation)
> through sysfs, the relevant sysfs nodes are as follows:
> 	1.analysis_trigger
> 	2.defrag_trigger
> 	3.fragmented_size
> 	4.defrag_size
> 	5.progress_ratio
> 	6.state
> The detailed definition	of the six nodes can be	found in the sysfs
> documentation.
> 
> HID's execution policy is given to user-space.
> 
> Signed-off-by: Huan Tang <tanghuan@vivo.com>
> Signed-off-by: Wenxing Cheng <wenxing.cheng@vivo.com>
> Suggested-by: Bart Van Assche <bvanassche@acm.org>
> Reviewed-by: Peter Wang <peter.wang@mediatek.com>
> Reviewed-by: Bean Huo <huobean@gmail.com>

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
