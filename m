From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/8] megaraid_sas : Support for secure JBOD
Date: Thu, 8 Jan 2015 02:41:35 -0800
Message-ID: <20150108104135.GC600@infradead.org>
References: <201501051440.t05Ee5m5029978@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38988 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753784AbbAHKlh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jan 2015 05:41:37 -0500
Content-Disposition: inline
In-Reply-To: <201501051440.t05Ee5m5029978@palmhbs0.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit.Saxena@avagotech.com
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com

>  #if defined(__BIG_ENDIAN_BITFIELD)
> -		u32     reserved:25;
> +		u32     reserved:12;
> +		u32     discardCacheDuringLDDelete:1;
> +		u32     supportSecurityonJBOD:1;
> +		u32     supportCacheBypassModes:1;
> +		u32     supportDisableSESMonitoring:1;
> +		u32     supportForceFlash:1;
> +		u32     supportNVDRAM:1;
> +		u32     supportDrvActivityLEDSetting:1;
> +		u32     supportAllowedOpsforDrvRemoval:1;
> +		u32     supportHOQRebuild:1;
> +		u32     supportForceTo512e:1;
> +		u32     supportNVCacheErase:1;
> +		u32     supportDebugQueue:1;
> +		u32     supportSwZone:1;

This is another candidate for using a u32 with bit wise flags..
