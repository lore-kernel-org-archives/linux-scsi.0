Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31C0F3B7A8;
	Tue, 25 Jun 2024 21:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719350841; cv=none; b=qu+EOzbkoLqPbOO0/YTtaGuC+dK0BUbfYXxmQIj/BnLgl9gHEa/wbjHKnQWfT/VxIvEyHT2I9CZIReh2P43p7UM3rAUo6uHl8THlVIjxB0OozQi8c4PYmdKDsO9vzGcBnDYv8BcG0XieIsASLgomDbstmGlV2TVKapT+58U5XZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719350841; c=relaxed/simple;
	bh=QrcrL+iK80cITAksG8iEQXSCYhI3jc6fSV3OVuLqCFM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XAHyp+VSXBC7NREkcaTWC102zl5PIczUw/J0IUpOyhXPXJMLiDNec31pCodw446oqf50k7zLfKpGzEgb67hXF8RcKQgqLPyb18B4bJW3AgNvC0rtA6zMpTUugLw+czYl1yot63OjLHJBa+wZNbAWXuVQ+KPGXzZOUip8GmrW2zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HZS7JlcC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HZS7JlcC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19171C32781;
	Tue, 25 Jun 2024 21:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719350840;
	bh=QrcrL+iK80cITAksG8iEQXSCYhI3jc6fSV3OVuLqCFM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=HZS7JlcCxUVm5oTB1EAp6JBfTypnmomDFN1ghmNMjKow6eFofnIESZcMsL0SSnc+T
	 hkxxfpf47HI7kFtuBO61aBfNzVy7NA4vTUoMOV2NMw7RTLPdLe3bjtMw20Q42rB7Ja
	 xEGVBlZYFy92ktog66njhefwGaL3rmhQOeI5vjRKFy+a7RpW7gnk1dpzZAiHWzcTdM
	 YunWOp1NPb6mNif1XVF7ezc8I3WozkRCDHxj2uDEGZOHx+bIn/5GFaXdLvbRSJ0y3L
	 /e0Km9GQeZ/YhNr3i/3XY1v51WkxrXCJCiKDnEO9oSjwwkKlmNJpMfc9fT+oxkH1Dr
	 u4mhkmeobA/Dw==
Message-ID: <271ae637-077a-4495-b234-d7f884e14b29@kernel.org>
Date: Wed, 26 Jun 2024 06:27:18 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/8] block: convert features and flags to __bitwise types
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Niklas Cassel <cassel@kernel.org>, Song Liu <song@kernel.org>,
 Yu Kuai <yukuai3@huawei.com>, "Martin K. Petersen"
 <martin.petersen@oracle.com>, Alim Akhtar <alim.akhtar@samsung.com>,
 Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>,
 linux-block@vger.kernel.org, linux-ide@vger.kernel.org,
 linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20240625145955.115252-1-hch@lst.de>
 <20240625145955.115252-5-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20240625145955.115252-5-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/25/24 23:59, Christoph Hellwig wrote:
> ... and let sparse help us catch mismatches or abuses.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research

