Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC4DB36B;
	Mon, 10 Mar 2025 00:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741565101; cv=none; b=axndeY0PjF2xSz9bwbr9tFxiAqc06uP6iKM96VzwZgATMRSzv+sjfdlfhsT3NZBOz4yCcbnJRJWbhHsXC2Kw8KmTrpkEDk0Sn0PRSLOu8bGdI7R4ROv4dbUykjEhFT5eiGuYRavzBy8xVaI5x3qaKExhwjWQ26veJs5GhCF7QxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741565101; c=relaxed/simple;
	bh=0LYoAug6EtstXEbQxZUT8fRG3JRcCzgIe7D+PD1Gowk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gTlR5IfNBkCOyBOItsebdU/AsJiV0CHl4kVRtdhpyqNHCcitilYzNLOLo2OZMS0WIxrgaWg7IwRYtATWK4vgWgy1MKhyYOkO2puu68QNYtYRtesXfZFkKQ3MwId7QvZ5W+SuW5C8Fnj/y4Q/2AJF6XIUW+wyTvSe9dzv7kzblDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dpz64GI3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dpz64GI3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C5E1C4CEE3;
	Mon, 10 Mar 2025 00:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741565100;
	bh=0LYoAug6EtstXEbQxZUT8fRG3JRcCzgIe7D+PD1Gowk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=dpz64GI32UgpU7eK/UTbWJzXuKqLE4Leqevgps3pFRYaWCu7AA3zI6D8dhF4wXZfC
	 Q15HC50+rJ6viVghAtowm4iMU3yd9qaD6kkp755gkRymdmaesrszcIQA6U0CkHTTcM
	 hz6sxt3lZcUsCljmLTBU1OziR2CqX8hvJjr7OngdM8SQMQcQS9dUamZV6TgIAR8q1U
	 zdvS9U6aFRkho9Hls6y1LFHwm5zxRH9ToNwAznRLB+KWvVJnuPTVMtwrGfaFpPO3HX
	 wF4OhwVmdpWE/OCCeHn2wByxNDOxI2VjcUW0S89tWOMBDQ4zVOvbLcoiLqo3TxVvII
	 HzUA/lTWjD4dA==
Message-ID: <cb0c2d86-82f5-46d3-8d72-826f0bdd6dec@kernel.org>
Date: Mon, 10 Mar 2025 09:04:58 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: megaraid_sas: static most module parameters
To: linux@treblig.org, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
 shivasharan.srikanteshwara@broadcom.com, chandrakanth.patil@broadcom.com
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20250309143348.32896-1-linux@treblig.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20250309143348.32896-1-linux@treblig.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/9/25 23:33, linux@treblig.org wrote:
> From: "Dr. David Alan Gilbert" <linux@treblig.org>
> 
> Most of the module parameters are only used locally in the same
> C file; so static them.
> 
> Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>


-- 
Damien Le Moal
Western Digital Research
