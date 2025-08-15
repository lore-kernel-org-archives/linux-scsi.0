Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28AC02951BD
	for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2025 02:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755225170; cv=none; b=Xvhb3EIIe4JVvPNH5mL/8++S5NGnZhK+rfSJcWtGJ8ZHO1xMz+LiWCh1jUNTdtIbJEjCLiZNjSIvH+h2epd43O5+BbF9VbpHEoSQnDLCcVqAKQInl5vQflxb9oWEPPUa0KJew5P+kXvImZN9uFtZa3qiflmFA/8KyxUiI+pqmxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755225170; c=relaxed/simple;
	bh=p7DL9YEbnuLnJ+slJuNj3TQaj+Y2uJOg/FQXUBK3ASY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aEvRkqk4Fv6+MzeARNSuGus6aF1ZHLGDNXOyaTf2OgOegr98N0ddsXc56tMjIVmCqe1FFSNf71g9cbQMTZ3+kjZxKLR2N9+4Cf7wwu6Q7jsdnvygg/Zko1z9fwpnG4OykNKCCQJVKAGdho5CdOdAhYrEPJ4tWb2H/wSJBESccx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FZ2Rq4A2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FZ2Rq4A2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E0D1C4CEED;
	Fri, 15 Aug 2025 02:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755225170;
	bh=p7DL9YEbnuLnJ+slJuNj3TQaj+Y2uJOg/FQXUBK3ASY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=FZ2Rq4A2bAAuQ6eXjx39srysOvzfYOhMwblDJB1Um1kNOuX1SJlLo/KIpXiYUq4F1
	 OcFuwuBYhsFnvdcUQmSHx53PRb6Mxh3X2hu6O5e5tbTiCWJlOD3gMSuIpC8LIv9Kiw
	 HY+DKJqxwZxOgsWwWNyDIK0ZmBvUnzTzi7mIlZTquOdUyGH0+CUaAMkh8KpzT1+PAe
	 5ic2zBE4TgVJbq4tSlYlyA/ff+TaquKM96AsH/OyTmRtXA9ZrvJ2n72LjV/CvpMYdy
	 bX/Lzd+XD2JD8oF1hlvxkE38rxEaxLGyGZ9y1/6xrWZh1AMWCJlL6Qg3Guxusv3EKO
	 c9basbIGkrbFw==
Message-ID: <c53e2b2e-8704-4f89-9489-4f9f8ca5e3da@kernel.org>
Date: Fri, 15 Aug 2025 11:32:46 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 06/10] scsi: mvsas: Use dev_parent_is_expander() helper
To: Niklas Cassel <cassel@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
References: <20250814173215.1765055-12-cassel@kernel.org>
 <20250814173215.1765055-18-cassel@kernel.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20250814173215.1765055-18-cassel@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/15/25 02:32, Niklas Cassel wrote:
> Make use of the dev_parent_is_expander() helper.
> 
> Signed-off-by: Niklas Cassel <cassel@kernel.org>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>


-- 
Damien Le Moal
Western Digital Research
