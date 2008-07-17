From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 4/8] scsi_dh: Update hp_sw hardware handler
Date: Thu, 17 Jul 2008 18:30:08 -0500
Message-ID: <487FD600.1060000@cs.wisc.edu>
References: <20080717073827.155C018C6FD@pentland.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:58689 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932078AbYGQXaT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jul 2008 19:30:19 -0400
In-Reply-To: <20080717073827.155C018C6FD@pentland.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

Hannes Reinecke wrote:
>  	case NOT_READY:
> -		if ((sshdr.asc == 0x04) && (sshdr.ascq == 3)) {
> -			rc = SCSI_DH_RETRY;
> -			h->retries++;
> +		if ((sshdr.asc == 0x04) && (sshdr.ascq == 2)) {

I forgot what we decided. Was this supposed to be 2 or 3? If it was 2, 
then patch looks ok.

Acked-by: Mike Christie <michaelc@cs.wisc.edu>
