Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A619428690
	for <linux-scsi@vger.kernel.org>; Mon, 12 Jan 2026 14:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768227684; cv=none; b=rWK/5tP6QJYdtcK/N3j+2Av52PR36Tq1WGAOELH/BbTnWkYYXaJ+AsJzgVPXXMMQcB46NypGkY3JbZXNHsn6vlW6YyTDLl0pfM9KtXp+42swcuo4VeUuTlxJYpuLhGCAJXAnhhmTgzYchoyMV9t2aHEmGj3Ye6I/tf+SeQgRcrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768227684; c=relaxed/simple;
	bh=KUCdlzCF/NMvbzr/IP2k3UjMzAFFPsk8/UCf0rjb1OM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HwI90KrH79Vm/iGi4VQDVKF2zs9vbobGmq+hKn4SNUP7fxTDHAnH2AU7Wu3JRK9qe1Clt4g6wQ6zFcNXIr+AdiEmfU4T68amIMg/m71eqzl74a0PT81gZYxd0hB+UWDip/0BF+h90xGhnCiHSSayDLkK+Vm/rSJZ7iiYYBVarv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=enGq6aR6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="enGq6aR6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6257BC19425;
	Mon, 12 Jan 2026 14:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768227684;
	bh=KUCdlzCF/NMvbzr/IP2k3UjMzAFFPsk8/UCf0rjb1OM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=enGq6aR69GQDcQGb+K5QLD+LNvZg/AY/aE5jg5BTbo6x1JyT3/CBTUJIV/qpchOTn
	 RjRzegSR2P3UbXTouKKSke01QCPBtn73MYA+HaApOOUdtY/SKLtBaPXUBRYYie0/FZ
	 3kLXUYG6IsmDAvCg3LJ1XwX+pZe7CCu6vf3XMuiNC5b0HW1sOIyYRxrEryaSZkqFZ2
	 xojSxLjymzb72Px33nUGUmWTatgZls/FaN5Dq0DB9qVOxhcyhhY7RqgJEN8/rFqOCl
	 pGkExV5266slWi3dfNpf8qFWGu1BY4dltg9CI+Vqbukz13+YChF7j7KGCiXOHXifkS
	 qXtT+TjHTKOJw==
Message-ID: <67011328-cbe5-40b6-8bc2-32b4f2c43592@kernel.org>
Date: Mon, 12 Jan 2026 15:21:20 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 5/7] mpi3mr: Update MPI Headers to revision 39
To: Ranjan Kumar <ranjan.kumar@broadcom.com>, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com
Cc: rajsekhar.chundru@broadcom.com, sathya.prakash@broadcom.com,
 chandrakanth.patil@broadcom.com, prayas.patel@broadcom.com,
 salomondush@google.com
References: <20260112081037.74376-1-ranjan.kumar@broadcom.com>
 <20260112081037.74376-6-ranjan.kumar@broadcom.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260112081037.74376-6-ranjan.kumar@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/12/26 09:10, Ranjan Kumar wrote:
> -#define MPI3_EVENT_DIAG_BUFFER_STATUS_CHANGE_RC_RELEASED             (0x01)
> -#define MPI3_EVENT_DIAG_BUFFER_STATUS_CHANGE_RC_PAUSED               (0x02)
> -#define MPI3_EVENT_DIAG_BUFFER_STATUS_CHANGE_RC_RESUMED              (0x03)
> +#define MPI3_EVENT_DIAG_BUFFER_STATUS_CHANGE_RC_RELEASED	(0x01)

Why the alignment change ?

> +#define MPI3_EVENT_DIAG_BUFFER_STATUS_CHANGE_RC_PAUSED		(0x02)
> +#define MPI3_EVENT_DIAG_BUFFER_STATUS_CHANGE_RC_RESUMED		(0x03)
> +#define MPI3_EVENT_DIAG_BUFFER_STATUS_CHANGE_RC_CLEARED		(0x04)

A white line here would be nice to separate things.

>  #define MPI3_PEL_LOCALE_FLAGS_NON_BLOCKING_BOOT_EVENT   (0x0200)
>  #define MPI3_PEL_LOCALE_FLAGS_BLOCKING_BOOT_EVENT       (0x0100)
>  #define MPI3_PEL_LOCALE_FLAGS_PCIE                      (0x0080)



-- 
Damien Le Moal
Western Digital Research
