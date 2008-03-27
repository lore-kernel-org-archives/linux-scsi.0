From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [patch 08/11] zfcp: Add traces for state changes.
Date: Thu, 27 Mar 2008 15:20:01 +0100
Message-ID: <20080327142001.GA4122@osiris.boeblingen.de.ibm.com>
References: <20080327132154.826339000@de.ibm.com> <20080327133028.840759000@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:38788 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490AbYC0OUE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Mar 2008 10:20:04 -0400
Content-Disposition: inline
In-Reply-To: <20080327133028.840759000@de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christof Schmitt <christof.schmitt@de.ibm.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Martin Peschke <mp3@de.ibm.com>

> -	zfcp_erp_modify_adapter_status(adapter,
> +	zfcp_erp_modify_adapter_status(adapter, 24, 0,
>  				       ZFCP_STATUS_COMMON_OPEN, ZFCP_CLEAR);
>  }
> 
> @@ -216,7 +216,7 @@ zfcp_erp_adapter_reopen_internal(struct 
>  			       zfcp_get_busid_by_adapter(adapter));
>  		debug_text_event(adapter->erp_dbf, 5, "a_ro_f");
>  		/* ensure propagation of failed status to new devices */
> -		zfcp_erp_adapter_failed(adapter);
> +		zfcp_erp_adapter_failed(adapter, 13, 0);

24, 13? I bet you made sure that these numbers fit the huge list.. and
hopefully nobody will ever add anything in between.
Why not just pass a string? This looks way too complicated and error-prone.
