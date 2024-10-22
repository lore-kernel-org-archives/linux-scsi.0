Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A543D188918
	for <linux-scsi@vger.kernel.org>; Tue, 22 Oct 2024 21:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729632627; cv=none; b=hNQb9KFitwAXz7K8hk6j1mkKMX52wmiZuBMKlstO3k3VXEy4WPuVa2aiSbKOsVxYwWE6R17iLVg3G2SfUOuG+RLJIbqjWT7txG0Xctq+lwBu2D1BEsYLnXUIJhSVqarduPVdCSoUFh5N8PXT1nZBJFcN7gKg/cN9FWgqb+nhrJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729632627; c=relaxed/simple;
	bh=Hgl4P/13iHPAwhNfk4QVcCfaE/hcYeR3mqSdEfRYjFg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bEIPJQKeu0jc4bLm2S0zCCVWTKmsV2ZeAVoT0fpObqGT36YA7pPqLHow7q1J9L0v1gQGklHhurdPDvp/OQrZZeufqNfXpELxfLfgM9qh0YzNIMnv3dQ3JliGeT4Ata7oOZPB3PbbRMg9gurOs5aYWtiEB0yOuh5GQXD5jSW0GYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d1MECYoA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d1MECYoA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A7FEC4CEC3;
	Tue, 22 Oct 2024 21:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729632627;
	bh=Hgl4P/13iHPAwhNfk4QVcCfaE/hcYeR3mqSdEfRYjFg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=d1MECYoA1YprtAitjlv91wnTqrXBxNFvtE30al6lNIHXfGYXsKdpiX/bbd9u7ilTL
	 QPw0H9ZBFbTRIzFEh/ugxmlaqUCZIB+xIRnJNtoupr8QkYO5xlR81S7O0vhgbEMTQC
	 GYFSCdyAkvEZtRhvLok/oVcitqTLAyNicTYGQCN+IwZyk5mRJmLzu0E90OfeGwQjeL
	 vUWVqQBCfcvhvFr4hHyF5cLwrDGCUfJG+srFf6Gu05H5KT3OT9U1PBrZ8uB08xNePI
	 aXklAidKecymkxXH2bNvaO/L9y9H6EyaRJcuVabdtru4YolqCJX2DJNWd84Fth6V7h
	 hSoHIthqZ3cog==
Message-ID: <c4cba23c-82f5-4a0d-a730-8771b685cd19@kernel.org>
Date: Wed, 23 Oct 2024 06:30:24 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 5/5] scsi: core: Update API documentation
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Randy Dunlap <rdunlap@infradead.org>, linux-scsi@vger.kernel.org,
 Jonathan Corbet <corbet@lwn.net>
References: <20241022180839.2712439-1-bvanassche@acm.org>
 <20241022180839.2712439-6-bvanassche@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20241022180839.2712439-6-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/23/24 03:07, Bart Van Assche wrote:
> Since the .slave_alloc(), .slave_destroy() and .slave_configure() methods
> have been renamed in struct scsi_host_template, also rename these in the
> API documentation.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Damien Le Maol <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
