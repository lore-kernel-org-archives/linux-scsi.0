Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FE6C12FF69
	for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2025 02:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755225213; cv=none; b=SL7WkXLoy6ddKk86104r8f/1h2AhOkI5rXG6FAvC8Y7gNEGi8AlDjeHyuHb0luvFLbR0nK1MN6at/HJQGfw5qaSBFAAUraFZz/YipTebgzXLhBMqeGQesNhRWvmz3F57bfuZfWV+53hAw5hv1aKKYL5Aw7HGtJuM7N+pEQoyEUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755225213; c=relaxed/simple;
	bh=p7DL9YEbnuLnJ+slJuNj3TQaj+Y2uJOg/FQXUBK3ASY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gpR6mvcb40OqhFHB0JzEH7voYGNL16JCXIgDTm3z73wvl/DE89D8qN2QegS8ibl/bksMSEN+d0VRTjDaI8O33Jz7zQSGUeIMtr283IGI2T9BhsoD2pwi50r7eZpeHzzRrygxuBXckiOGMc7lmekvoswi6yTO2vSrPemF0+Viuzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BkozHKhW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BkozHKhW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 342FDC4CEED;
	Fri, 15 Aug 2025 02:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755225212;
	bh=p7DL9YEbnuLnJ+slJuNj3TQaj+Y2uJOg/FQXUBK3ASY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=BkozHKhWFNrdblELID1XpWTaGsGE7ZhXz37jpA1h4zfv0ef2bs5ZJfNS4iukTCq+q
	 gNCFPQpZlC9rg6KCgMd4iydCyjOngspYcT6Qu+/SznnMnhB6F1foWqw5OOvYrYjEnH
	 F054GfCx71l+Hm9xPJYccjN/XCSoYFmfvSt9qtOcw/0nsVSP1qyTpxehFqrKFQbuC/
	 nBAQ482kGtz16/aNj5UOcGmJ2jV4UZ2amXtB/oS+f1Q7bI+18oKOyJqJskaDvrUc7m
	 Kv+vTIZmvhafxRSObAdXwdnGQAsHIFV1GU3kw19joOWLuNGo+Fz7DqjW5RklMpmopA
	 CtMrXDrJLkS9w==
Message-ID: <9eb07507-bc93-411f-8a37-4a9e4382baba@kernel.org>
Date: Fri, 15 Aug 2025 11:33:31 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 07/10] scsi: pm80xx: Use dev_parent_is_expander()
 helper
To: Niklas Cassel <cassel@kernel.org>, Jack Wang
 <jinpu.wang@cloud.ionos.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
References: <20250814173215.1765055-12-cassel@kernel.org>
 <20250814173215.1765055-19-cassel@kernel.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20250814173215.1765055-19-cassel@kernel.org>
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
