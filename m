Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 706C3374A14
	for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2026 06:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790576729; cv=none; b=JqpYZeOc1F7i8uWmAm7tHasHXCK4UkcPyDYCvDrDkW7SjUJr9/MqAbqZtLM0sZ+DzROKaIjD4a7eqcSSgncrsmrMX0VD/Il6Aly6EjQ8PFFiaS9jrlt8dc6WY8bcH4mOQObJ/hh2aaPJ+xjD8Lw2q5A3pBN4rrtToOUumDgP1PA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790576729; c=relaxed/simple;
	bh=TMvRzD8ctcZZmISDPutNliMcQgceaKSIsuisJBG6eoM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BA176k3++rwZaiGRz8d1ZL1UDC5MXQtpbNfqWx3XrwZXTsvJwJwArXQD+t3F76kb1Vuo0ZV1/YlSekD4By8XF1xDZyx/1ouHZJsagtfZatTh3fRGwHVWzFMAneFoYAS71aMi36aCnj5Mtv0ql61de3jFRtZiigU8cFfoRd2sKQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h9wOf28D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h9wOf28D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA0181F000FF;
	Mon, 28 Sep 2026 06:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790576728;
	bh=R7D/aeI1MkN373MeoIvM6NE0VGLjyiKwcH5C6fn7zgQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=h9wOf28DQW9QqWYqgCR9io9KJrKY6aAw8H0NBKLTZx27lH4UF2rqF6YyfGOJ2EIVm
	 vDHrHm6jgMCCipK+EBdU0gBWd7wpNBVBbIiKv4RuuXiSD5DUKE+0fRTeJPHco0eEHL
	 tliQt+rYeDHDf9NIIaZB6bmoe3xPG8vjQCISedohK5fzLRPOshkByL5R5B3HpCzOUn
	 Wy+2TCEJ204sGz5Yi8YeTbJF5b3SHZbq5XgFB/Y+9UNl8aJE6K2TUIUhdd27MgcxXL
	 dlfoLy1c0NhuuxO1Wl5rj+tJeil87A7VQoMyxegwaFwyJGvsSivShEdi0UfpZKspiM
	 51UlnRD1GFq0A==
Message-ID: <cc4e69bc-38ec-42d8-94d1-b3e56db52bec@kernel.org>
Date: Mon, 28 Sep 2026 08:25:25 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: core: Fix scsi_done() documentation
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, John Garry <john.garry@linux.dev>,
 Hannes Reinecke <hare@kernel.org>, Jonathan Corbet <corbet@lwn.net>
References: <9d10e1068d75c1a708b3a56e85782d651411fe06.1790359673.git.bvanassche@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <9d10e1068d75c1a708b3a56e85782d651411fe06.1790359673.git.bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/09/25 20:08, Bart Van Assche wrote:
> Commit 11b68e36b167 ("scsi: core: Call scsi_done directly") changed
> scsi_done from a function pointer member into a regular function.
> 
> Replace all references to the scsi_done function pointer member
> with references to the scsi_done() function.
> 
> Cc: John Garry <john.garry@linux.dev>
> Cc: Hannes Reinecke <hare@kernel.org>
> Cc: Damien Le Moal <dlemoal@kernel.org>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>


-- 
Damien Le Moal
Western Digital Research
