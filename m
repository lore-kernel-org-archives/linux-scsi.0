Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F17E1E4A2;
	Mon,  4 Mar 2024 23:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709595619; cv=none; b=Ub3nlkGR7l630aqRXQHGpGT95d4Lw+5UBspzbt3wq6tn5UHrUyLxtytk8HAF/f/Ih+c/EEsseqAzYpsbdbmPpOMvlYrOnbi/5jLdIxsM+ydw6sU1nFh0/kxZ5zGPmQHrr13JCDRQUCSQt/0VfOZYUfjsTwXFF9u0ulni6mCYFAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709595619; c=relaxed/simple;
	bh=qWunR2PHRPgc28nLi8EbAQUGH1RblUct3QxLOxF065I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=V4QURdNUHz1vlazP0U58UQjpYjDJRKLCRvnWdOzBOZTDFVWbZWfQIOxrHlZo0qv++FYmNbd+LRNgtePNeAkLrCqbkWlK3tr0bN/iajD0DiZAxI35S2RGXZjWlFb3e/Tq4fZB2DUJYzwfe5lqgF2qqR++eDQzPkGO0f1IbSbyyLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Tk6Az5Vk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Tk6Az5Vk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98736C433F1;
	Mon,  4 Mar 2024 23:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709595619;
	bh=qWunR2PHRPgc28nLi8EbAQUGH1RblUct3QxLOxF065I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Tk6Az5Vk+i8/GyEIlQvdSp4O0sa1bQYlM0kciEY4gxSPaXXufPaUvA9LQRRz53YxF
	 gKGtmu/7Qehaa9GZRtlgUGpbjyfd8ASURbOSkHQMbLGDHiFCWErVLIw3u1eeeGxruR
	 9Jzi09DC+KDhQ+/VQyAJ3vp0F6mSu96EIA/Vh8+Sseii119mxOocrSFRPNGk8QUaQF
	 DcOxXuFMc2c1DYcIW+6lsROJFUit5XsnufiODS04MCs4h7vOHmZC5St+jo+2gmngh2
	 a6vyh8GC9xtTXMlluDdMQbL7lYNUm5tPZRIR/c6vitTdnZmbA8OACA2UnCM9E1YHlj
	 lPOVq+Eh4qyuw==
Message-ID: <9b0c113e-21b4-4c58-9554-ba005f8f5f9a@kernel.org>
Date: Tue, 5 Mar 2024 08:40:15 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 7/7] scsi: isci: Add libsas SATA sysfs attributes group
Content-Language: en-US
To: Igor Pylypiv <ipylypiv@google.com>, Niklas Cassel <cassel@kernel.org>,
 John Garry <john.g.garry@oracle.com>, Jason Yan <yanaijie@huawei.com>,
 "James E.J. Bottomley" <jejb@linux.ibm.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Jack Wang <jinpu.wang@cloud.ionos.com>, Hannes Reinecke <hare@suse.de>,
 Xiang Chen <chenxiang66@hisilicon.com>,
 Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
 Bart Van Assche <bvanassche@acm.org>
Cc: TJ Adams <tadamsjr@google.com>, linux-ide@vger.kernel.org,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240304220815.1766285-1-ipylypiv@google.com>
 <20240304220815.1766285-8-ipylypiv@google.com>
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20240304220815.1766285-8-ipylypiv@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/5/24 07:08, Igor Pylypiv wrote:
> The added sysfs attributes group enables the configuration of NCQ Priority
> feature for HBAs that rely on libsas to manage SATA devices.
> 
> Reviewed-by: John Garry <john.g.garry@oracle.com>
> Signed-off-by: Igor Pylypiv <ipylypiv@google.com>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research

