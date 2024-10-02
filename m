Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D908F12E5D
	for <linux-scsi@vger.kernel.org>; Wed,  2 Oct 2024 22:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727908694; cv=none; b=rDt4/4XjKxD+bApP3ulZuYBSaRCcEOa73tu6r7RPVsbSu6tdVySHdf8fqwFFes0mnJM+Tx2JDy1YOpRWqUSM9GC0XbFamkSy6rYkS+XnDtA3T2WVDYJWDZAqJ44S50yZJM7p/7KmNf3eQLQrEo+YIF6QiuqwxsDbzybyCIxERk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727908694; c=relaxed/simple;
	bh=SqNVMX1ZWlgcNkShF/5jYS8hU2wantNF7RakfsmK6G4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jP/x1sBkXOaYRA0bjGrUQrVxXpBU3mt7fbeu7+kOrhdU3Dyn4p2gMaSUif9Xa46/kKiRjWAyw/r3mH2LkBqW2UVUzSPYtXe5eF7rBX6PiVzz2b9sePPC8+UVrXdhBfpMcASp2xsa8/NnzCqmBnSIu3H7m9UBJHB4UNehqT1z8RQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ix6XhKl6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ix6XhKl6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 337D6C4CEC2;
	Wed,  2 Oct 2024 22:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727908694;
	bh=SqNVMX1ZWlgcNkShF/5jYS8hU2wantNF7RakfsmK6G4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Ix6XhKl6IIhB2B3wDtn1nOPs97Yk0XnsN1Xr22eqEfGNXPGdF0/pBKujNouZEDMYd
	 uxa0BMdk2KWdsyWSbPtCO0W0a1vQnhNaUi+uHnVrnDEm46ZbFqoHHOlYX0nc4BYvfr
	 B4BclG9BIJOl/Kib6ZkzevXxX9doHme3pjgZXcmsxwb/kWSTVdAisCBY3gTMoTfMM0
	 prn8v02y97l1Z/tflOF74YyLxMSt25ccSfQtdYDqmZqULKZAym6VnaN516uUmzknVb
	 xY660F3ZmtrAItRF5kCZMFYIwpOjkTFtmxnJbknmHdmYyTZp8Xib+f3kMepNeovgA9
	 yWgwJxTnZgXGw==
Message-ID: <2f304d8b-73ed-4c85-ba8b-113fd8a44b61@kernel.org>
Date: Thu, 3 Oct 2024 07:38:12 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 10/11] scsi: core: Remove the .slave_configure() method
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20241002203528.4104996-1-bvanassche@acm.org>
 <20241002203528.4104996-11-bvanassche@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20241002203528.4104996-11-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/3/24 05:34, Bart Van Assche wrote:
> Now that all SCSI drivers have been converted from .slave_configure() to
> .sdev_configure(), remove support for .slave_configure() from the SCSI
> core.
> 
> Cc: Damien Le Moal <dlemoal@kernel.org>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
