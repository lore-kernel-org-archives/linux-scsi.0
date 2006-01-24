From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 3/4] aic79xx: SLOWCRC fix
Date: Tue, 24 Jan 2006 10:53:23 +0100
Message-ID: <1138096403.2977.36.camel@laptopd505.fenrus.org>
References: <43D5F706.30009@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:37100 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1030415AbWAXJxZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jan 2006 04:53:25 -0500
In-Reply-To: <43D5F706.30009@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2006-01-24 at 10:44 +0100, Hannes Reinecke wrote:
>  	/*
> +	 * Slow down our CRC interval to be
> +	 * compatible with packetized U320 devices
> +	 * that can't handle a CRC at full speed
> +	 */
> +	if (ahd->features & AHD_AIC79XXB_SLOWCRC) {
> +		con_opts |= ENSLOWCRC;
> +	}

since this seems to be a device quirk, shouldn't this just be part of
the scsi blacklist and have a quirk there? Maybe with a generic option
to trigger that quirk as well rather than a per driver module one...


