Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9358E2D2384;
	Tue, 25 Nov 2025 08:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764058825; cv=none; b=CYZk05J/HIRmMOPcl9cMOBu8t9mhCIousymCafiazLIpJqQkVj2ve6+WRolrq492DtqLVgQma+sLuubfdFXo29uZSOqeLaBU7dJ/I7dqxB23hxn2oAFwbnt80IrR6M4FTOF99TmclAasrWkrJ97UMlSuXlxZab4Xn3mhP3IpGZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764058825; c=relaxed/simple;
	bh=lcOpoPYv+NRnxQY8W/oWlW2Bjz+gFrcw+b5Ftw2ox2k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IlI0WXcxFKZEpON8Zq/rJfzIPHTkcWezwAuwyazxQT30Z19Df/mtuw4AX7SfWHx0zl9smlFxIihpuk1u9GQcU6Ww0qVKnvf5LmA2difr61MOBgJ+NVVc362toJf0FZYonVoubzXejU7cz3HvMedHuSdPUBdmgaUINJeTX8Z/gGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a+N6Lxul; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a+N6Lxul"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B343C4CEF1;
	Tue, 25 Nov 2025 08:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764058824;
	bh=lcOpoPYv+NRnxQY8W/oWlW2Bjz+gFrcw+b5Ftw2ox2k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=a+N6LxulZt9R4oOOqKDhp/dN63qEAr8s/Quv5+6ArIrCDERT+axQSRwP2ZEm+jcD7
	 d7b36PAhTyt+naiaYlSAnfcRzeCNNMGJjBMWt4UofeLbTECRckqxV9deQ9rJBHcu9U
	 rUMf/KkMkmxg+5TB3PfCtUd4fnpjtZs0bSEYrnstS5vpQu+bFr4p6p2su5u6SH1mJa
	 txrnLKmbexr2jJG3PxPdLaT3hoazTlVxyf5hqk/oLu0MjqgKfXgg37J8JXzoC1rxeY
	 oEN8VsaNvBvguTRZqk6VI9s64U011u8YCCd3rtV7e6cxOl39CCoFzxlO/pGpWU9Zor
	 vhceiY7SVQ0Ww==
Date: Tue, 25 Nov 2025 09:20:20 +0100
From: Niklas Cassel <cassel@kernel.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
	John Garry <john.g.garry@oracle.com>,
	Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 0/5] Increase SCSI IOPS
Message-ID: <aSVmxETXzs5kOVG3@ryzen>
References: <20251124182201.737160-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251124182201.737160-1-bvanassche@acm.org>

On Mon, Nov 24, 2025 at 10:21:55AM -0800, Bart Van Assche wrote:
> Hi Martin,
> 
> This patch series increases scsi_debug IOPS by 5% on my test setup by disabling
> SCSI budget management if it is not needed. This patch series improves the
> performance of many SCSI LLDs, including the UFS and ATA drivers.
> 
> Please consider this patch series for the next merge window.

Hello Bart,

The subject is:
[PATCH v2 0/5] Increase SCSI IOPS

AFAICT, you already sent a v2 series a few days ago:
https://lore.kernel.org/linux-scsi/20251117225205.2024479-1-bvanassche@acm.org/

I assume that you simply forgot to increase the version count.

If you respin, perhaps label it as v4, to make things less confusing.


Kind regards,
Niklas
