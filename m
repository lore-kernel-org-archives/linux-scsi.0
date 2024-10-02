Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D33019924A
	for <linux-scsi@vger.kernel.org>; Wed,  2 Oct 2024 22:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727908093; cv=none; b=FU21Wtb7z05zBa5oz5b92oMu1LeICnZ2OFBXhPVyukQHAL28ypFG1+u9j6pZtluWjRHEw+PS8kaFJQKMqoN2Y273HvhZrjM8LDte4ClWHzvKTczXGxXiTN2ni/hF6FGx3xnZZMBCnwJZR++c/Dl8mrTIdfAjRlFNVjrz79xp0L4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727908093; c=relaxed/simple;
	bh=aTkaZ77d7EpmzxrxiwpHhvPont+WBRNVlsb0ZQgW/fA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DVAO37GBrB9ySIJy/j751Wji5dKRv8PSfPS7I8mxtW3NOtCnvAFgZSiIH8dT6G0YlIAU3IARcf/woT3ayKA2tGcWXWCCiSwA8Hb/7HBs8cvyfKBDoEn6gnEx5Ss09v1S+59QNMTJjLHlP5cjbzcrfSF+4oJMFzpR6ykdOBe/ThY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k81xl+f0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k81xl+f0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C102AC4CEC2;
	Wed,  2 Oct 2024 22:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727908093;
	bh=aTkaZ77d7EpmzxrxiwpHhvPont+WBRNVlsb0ZQgW/fA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=k81xl+f07gelsdut2hqCYb1Ed3YPIj/qUWoSNZxjIJJKmhfmLQZj2KADeN2FINj4a
	 JE+x41jK0KKe7Xp0biZTvyI0FwjhfQUcss9CDx9ZzsXDUMEUdSOEA7YAreGfypWnlI
	 /MTSNzPiPLnxK4cRnQlIRZoQR/vfyE5Za2KYum1d2/hRRptkFUmcMlKC6akzLqwmFW
	 b0PsMd84+DM0jRw1HUtbQw24xoCIFKVijwmUpDmFjAm7gb2Z4hJOllw+3z4WQtvdEz
	 iW4Oo1KsSdwILnNXihfdZJq+RqLOG6sPvJQG1g5xmy3moF9ZrPkZklsF+Vg/sADmmz
	 4/NQCiQujvAzg==
Message-ID: <6fc86f8e-200f-42f0-a44c-079d06ce8f2b@kernel.org>
Date: Thu, 3 Oct 2024 07:28:11 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/11] scsi: arcmsr: Remove the changelog
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
References: <20241002203528.4104996-1-bvanassche@acm.org>
 <20241002203528.4104996-2-bvanassche@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20241002203528.4104996-2-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/3/24 05:33, Bart Van Assche wrote:
> Since we typically do not maintain changelogs as text files in the kernel,
> and since the arcmsr changelog has not been updated since 2008, remove it.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
