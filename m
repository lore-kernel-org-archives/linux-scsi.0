Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3748EA930;
	Mon, 10 Mar 2025 00:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741565119; cv=none; b=pDj19H94wWqD9CvWK8WVNfUW/Jc9Ip93F3zQKH6WSentlzkC/JTh99Ybbfxyd+ZEX2LxSSr4wdoBH6Pav0xSmAR+3bE17RAhltjfFpUlha24nsE/lk+gIcGbaIAdST3JCdLZEYPchyiOsjQQFkefnULuKaKDXozCQhtRMnSRnhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741565119; c=relaxed/simple;
	bh=xuO7LLZy9N08tyT0+EadcfCjEqszFaYWu8n9gcFiR3g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=c0H0rel9qK5lWUI/8RaQqEL19GJlh7u4ExVRglHvHByXM506M8UMXXzlEhNnU3XCADSuD3btMfkQ+2HhdBO8QO526nlXuftI4CKknIjMlTMZR/6IQuzi5/5z/Br66RkB6MUVW0E84yTdfsjoFa/l3nA2eLA5N/PVV5GDNuHCcOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MnKtARKr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MnKtARKr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63C01C4CEE3;
	Mon, 10 Mar 2025 00:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741565119;
	bh=xuO7LLZy9N08tyT0+EadcfCjEqszFaYWu8n9gcFiR3g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=MnKtARKrq1DyOV7QYWRNDJ9pxQS0dtChm/wmPLJAo8niLNwdJqSkN1hU+AEwlXWRi
	 z1QgZBTcrcQoAesE+dsNQjQyo5G/mt4oTWb1q9bpuw2Kh3Jels2NKsHbwFJ21qopF+
	 SxWa+FyXffINJywaJua8a9J8nu2FJwFEnOEREBVvIkaoUmW/loaiRI/E0YTMCprUz3
	 JBxq1uimfRf7Iywl3YygR4sOmvpfelpcE0oEEuQ0pwfGIQKM7Ma6EQTZqM1WJzvADP
	 v7lo+Q5lmMoH1sHC/7zeUDJWm+WDqFgi1/+WKy/oZ85xukYSjT84mRJ0ghrIeYZ/3i
	 vNjBKHultwREQ==
Message-ID: <0185695f-d9f7-4e0f-ba12-e3606534a807@kernel.org>
Date: Mon, 10 Mar 2025 09:05:17 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: isci: static most module parameters
To: linux@treblig.org, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250309145044.38586-1-linux@treblig.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20250309145044.38586-1-linux@treblig.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/9/25 23:50, linux@treblig.org wrote:
> From: "Dr. David Alan Gilbert" <linux@treblig.org>
> 
> Most of the module parameters are only used locally in the same
> C file; so static them.
> 
> Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
