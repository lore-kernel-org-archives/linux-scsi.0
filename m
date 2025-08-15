Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFC5E29B22D
	for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2025 02:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755225070; cv=none; b=bWv++i6ibVOHjP1hghCDvot/+5aV0WrJ266V5o8+0PsOrqHcFof5FTE38g5CF1+lUuCpXVgkiLqKFLz50KhybzU0NfZXS6LK3CSvwekot+U5wC/LPcNp7vj9A1hbg17RJk2sFOBQ9SONmR6wcvUJut2qAtdEG9He+/9bZYDIdJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755225070; c=relaxed/simple;
	bh=KJAB6pBPsU/qcex0e8qz1WMkt6UzuJBPJMMYNOaASbQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YPmHS5CYri+f4+WY94eF46b59QpHghm74Zg4gbuRCZuYGJpyP+1CmK1P9SjdZRMkh9of4nIBlWPbctz8SJuhyyH048KBcPBphq2uG9yN6bh95nQdHppsd3v7n0+AXi963ennXgWjNEBgxGlKL9jMqXICOugZcuxW2LDqJSroHmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vDMSNxuH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vDMSNxuH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB9D4C4CEF5;
	Fri, 15 Aug 2025 02:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755225069;
	bh=KJAB6pBPsU/qcex0e8qz1WMkt6UzuJBPJMMYNOaASbQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=vDMSNxuH5Bl2o4D5DoXmUWn9VBSaspqcpE2qAVHlIjyEN9N6LiktrOFaxE4d2mddc
	 52t6WxbnlcknxTa7YWvl6mX2vkfgVMxmOHs523GtEvrpXZ2Na8N+fMrxcGtqje8yNF
	 JZYANfIRYMdCDQ9R2+WvEyNSfdMR9eR7krQb6C1OeZfxWIWM8OT8By1S8GHk9Vk3uB
	 26K3l9MGveYaVumkfKhN8ZGqQQWmaAjbM8jjzdxmK5pMXwDlobNklDWelY3mp8I6e5
	 inffam5rmpJO1WnJwLf+/AGswI5DEGJuRZudIg+4nZKAheYc3XC0cb+uBhcOhd7xSi
	 7otzRjOJfn6iA==
Message-ID: <52002cbf-e44b-4709-9d4b-563ab83018f0@kernel.org>
Date: Fri, 15 Aug 2025 11:31:07 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/10] scsi: libsas: Add dev_parent_is_expander()
 helper
To: Niklas Cassel <cassel@kernel.org>, John Garry <john.g.garry@oracle.com>,
 Jason Yan <yanaijie@huawei.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
References: <20250814173215.1765055-12-cassel@kernel.org>
 <20250814173215.1765055-15-cassel@kernel.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20250814173215.1765055-15-cassel@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/15/25 02:32, Niklas Cassel wrote:
> Many libsas drivers check if the parent of the device is an expander.
> Create a helper that the libsas drivers will use in follow up commits.
> 
> Suggested-by: Damien Le Moal <dlemoal@kernel.org>
> Signed-off-by: Niklas Cassel <cassel@kernel.org>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>


-- 
Damien Le Moal
Western Digital Research
