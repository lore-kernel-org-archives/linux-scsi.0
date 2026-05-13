Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8A8D25B0AB
	for <linux-scsi@vger.kernel.org>; Wed, 13 May 2026 08:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778659469; cv=none; b=E562qx4zgNrXJw+7uxp7SWkluXNgCrG5n5Snw+pNHmTSQntV6vcteX8/SAiP+GEVMIkPhRlC7swK2VfQJl/jey6yq7J4iAQy0Nz2zG8fPghL9V/n9oohe+rNmhlS9s6QbN/h5K4XeJlWJJJK9yKhJpN0qcNonSt52L7APTkRpQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778659469; c=relaxed/simple;
	bh=NQ6mQgTeAlE9mhVVS9WmfQabMkyRm87OA9PnambOJqI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rYjWNJMoYD9xbiFl/tKOLmCr0RlkJVxpjvXAPR0YHK2YZPN0lZp7RdBtVdOS7Hb07T2JXXo9P/QQHi+DX5D69hM+laQOMVgCUvTvfmVjXlZ2aatOg2raWixZwxW/XIatq3vQlfrqYIbSrgxLlBpbNlVsSGRVc2SfB0wI8jtF4bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tWzZd00R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tWzZd00R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2BA3C2BCB7;
	Wed, 13 May 2026 08:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778659468;
	bh=NQ6mQgTeAlE9mhVVS9WmfQabMkyRm87OA9PnambOJqI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=tWzZd00RJbSrEQmGvEd4tx46AaIpGB4/TC22rwrN3FjMzF14P+Gi82g7FAMVmx73D
	 BCEC0BQopmoYgaGFjDIKN3eoHqqh5FLYRx34v+/6W34bMt8Ma6d2QA1H9V2xXaiQIC
	 oCwdA7VQKFKSEqoJX3d7qhB/EiCNjkwW5jPsIWj8E6e3UBS4v51oC4if3paGT03rBr
	 qONe/PBt01/CyM5iLpw5I2WKfgW/+ysrmYlYiWjlmhlmDYDqf31V8EgkyLg/wSUHuA
	 CZ75nWFbFov27UK/dni0mx/hOZTaFDU+XIO8E8k+ctWP34Go1+vaFmrSuyPg8PfES/
	 pQQp1+p2tPeGQ==
Message-ID: <cdc642dc-7396-4a73-b49a-dd98698f6785@kernel.org>
Date: Wed, 13 May 2026 17:04:26 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] scsi: core, target: Move three constants into
 <scsi/scsi_common.h>
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Brian Bunker <brian@purestorage.com>,
 Hannes Reinecke <hare@suse.de>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20260512194634.58145-1-bvanassche@acm.org>
 <20260512194634.58145-2-bvanassche@acm.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260512194634.58145-2-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/13/26 04:46, Bart Van Assche wrote:
> Prepare for using these constants in the SCSI core.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Looks OK to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
