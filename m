Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D54510A29
	for <linux-scsi@vger.kernel.org>; Thu, 25 Jan 2024 22:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706222611; cv=none; b=mbov4a8R2/rKnqEEcSBv2GqMVEu1yeUEbKz+R0cEL0j3TbUWFrnMHUT4QFyhhWAYrQL132V5o/I0tbUy7HJXUznfuuLKfVqREVrxX5w5ICA5qQ1udm2rG352lGVkzF15df1hzk2Lh/4nK0XQ0b91rTKSmcqBzuxAaKjlw4jceQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706222611; c=relaxed/simple;
	bh=FPs8tR/XBnPNNcPa/0J0zxqxeTepvMdWXXAOrBB1pT8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FIJRuCb/6sKc9CJcToDVHuWV5XY52nvS2qMfZUrwnVpLMF18kUkPvMI2cC0+SY4Syy38PRQT5G/l5O6Rus1VgILwJZI1HRLS0UCwQx8K6ILBhDLx4mOkfy2vBjKL1HKfhIkzcQO72D2US3/9nO7TNcg7VOlA19EuTcOFoD1PHlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MOjvnCXO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MOjvnCXO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B66CC433C7;
	Thu, 25 Jan 2024 22:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706222610;
	bh=FPs8tR/XBnPNNcPa/0J0zxqxeTepvMdWXXAOrBB1pT8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MOjvnCXOZLVoR1waBeco+lYXOlfFO2LBaOBRMg5/UyT1wS5+bCiZ3BNlrau0ITNFq
	 eEhG/6FZbBhk3e4wQYf5+srfYrtFox26I0RYzUOvGin3YuV6g+aHE/Tc7yCKrbv2yf
	 SWZWefCA9F3GK6DTH4yQBmoccuuyLvvJeiTKpBVE=
Date: Thu, 25 Jan 2024 14:43:29 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Chris Leech <cleech@redhat.com>
Cc: Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com,
	lduncan@suse.com, linux-scsi@vger.kernel.org,
	GR-QLogic-Storage-Upstream@marvell.com, jmeneghi@redhat.com,
	Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 1/3] uio: introduce UIO_MEM_DMA_COHERENT type
Message-ID: <2024012545-comment-subwoofer-16c8@gregkh>
References: <20240109121458.26475-1-njavali@marvell.com>
 <20240109121458.26475-2-njavali@marvell.com>
 <ZbGZ6zQDRqi5Bu_7@rhel-developer-toolbox-latest>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZbGZ6zQDRqi5Bu_7@rhel-developer-toolbox-latest>

On Wed, Jan 24, 2024 at 03:14:51PM -0800, Chris Leech wrote:
> Hi Greg, I'd like to ask you to reconsider accepting UIO API changes for
> mapping DMA coherent allocations.

Then why wasn't this patch series actually sent to me?  It's a bit hard
to apply something I am not even aware of :(

greg k-h
