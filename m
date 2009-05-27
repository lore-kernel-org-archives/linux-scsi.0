From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 14/24] mpt fusion: [2.6.30-rc6] Deleted functions for
	Firmware event implementation using seperate WQ
Date: Wed, 27 May 2009 17:33:53 +0000
Message-ID: <1243445633.6067.31.camel@localhost.localdomain>
References: <20090522110447.GH16331@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:40201 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756944AbZE0Rdx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 May 2009 13:33:53 -0400
In-Reply-To: <20090522110447.GH16331@lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Kashyap, Desai" <kashyap.desai@lsi.com>
Cc: linux-scsi@vger.kernel.org, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

On Fri, 2009-05-22 at 16:34 +0530, Kashyap, Desai wrote:
> Fuctions which are not used are removed by this patch.
> ---
> 
> Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
> ---
> diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
> index 10abd62..29a8fe2 100644
> --- a/drivers/message/fusion/mptsas.c
> +++ b/drivers/message/fusion/mptsas.c
> @@ -3035,30 +3035,6 @@ mptsas_find_phyinfo_by_sas_address(MPT_ADAPTER *ioc, u64 sas_address)
>  	return phy_info;
>  }
>  
> -static struct mptsas_phyinfo *
> -mptsas_find_phyinfo_by_target(MPT_ADAPTER *ioc, u8 channel, u8 id)

Please combine this with the patch that actually removes the last use
otherwise, for all static functions, gcc is going to warn about defined
but unused functions.

The 10 lines you save by separating this aren't really significant given
that some of the other patches are up to a thousand lines.

James


