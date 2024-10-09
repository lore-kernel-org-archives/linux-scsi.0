Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E255F208D0
	for <linux-scsi@vger.kernel.org>; Wed,  9 Oct 2024 04:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728447188; cv=none; b=CpskwiQXbQhXyxXF9/wWUrQdYGBbbu8OZ9feL4WBXeCR1TloU4kEFfh1O/Ix/ylyTClvdPFRrki2psho7c550c+eK5H/qNCcMNjLh1SX8BzXpWN8F41B01jYgBg7b4qr0lQxGJaSZZml/PSiEQ8X2iSPvWCBb+PC2/vrNkRWdK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728447188; c=relaxed/simple;
	bh=1Qe+1iGHr2EIQGPjYex0wft/kDg8yVJtcF9IPc3xMQs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pFBhh1nifpZhpPTbihREyOlp917xfsxdeSeNVtHgXAfQ0C4MpP05y5T/nd6NQoZXd3kKI4UmrpUfFm810wVQbIrO0IPmp73FwEWnJmF0R22UQvRSiD3F5AF8oJ0MhvqMBNhUq0m23AvrZq+VyQv6ELumHZEo3Z6QBVcYgpkJ5C0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NySYoybD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NySYoybD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8C5BC4CEC5;
	Wed,  9 Oct 2024 04:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728447187;
	bh=1Qe+1iGHr2EIQGPjYex0wft/kDg8yVJtcF9IPc3xMQs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=NySYoybDqIiREqXAyKcBhqAddnf3BbfYEHFMN/0pS+pxui7pYlVB/s4nF21a9KCWU
	 Q3cKlIkjssLfqDP7qmwoxinTTE8nu7efqvKOS/Fo+Pen8J1tPzSfsc1CsWxDnPd96J
	 s6PF6X+IZEEXKKpbjLKuEQlRY86g0VrE5oWwtmIiMKB0rF+El/jYvA2q69FXWWJefA
	 itrdLtoopRdjl1yngNbEimbuBoaTg8yj4RPkeqvQNsvF/v8cXYW6bEBFHXUvB2iG1l
	 ILeiQNXo7hCnnJ+tfu+RpjTgADKpAZk+6mGV9WNmsTNG0l7quuXSqeygzgrhFTEBrM
	 qCQnov6yS9PsQ==
Message-ID: <a90ef95c-8ac1-4694-8f69-056754298c49@kernel.org>
Date: Wed, 9 Oct 2024 13:13:06 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/6] scsi: core: Rename .slave_alloc() and
 .slave_destroy() in the documentation
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
 Randy Dunlap <rdunlap@infradead.org>
References: <20241008205139.3743722-1-bvanassche@acm.org>
 <20241008205139.3743722-3-bvanassche@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20241008205139.3743722-3-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/9/24 05:50, Bart Van Assche wrote:
> Update the SCSI documentation such that it uses the new names for these
> methods.
> 
> Cc: Damien Le Moal <dlemoal@kernel.org>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
