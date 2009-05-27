From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 22/24] mpt fusion: [2.6.30-rc6]Added support for
	Broadcast primitives Event handling
Date: Wed, 27 May 2009 19:27:49 +0000
Message-ID: <1243452469.6067.49.camel@localhost.localdomain>
References: <20090522111109.GP16331@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:55551 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752818AbZE0T1t (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 May 2009 15:27:49 -0400
In-Reply-To: <20090522111109.GP16331@lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Kashyap, Desai" <kashyap.desai@lsi.com>
Cc: linux-scsi@vger.kernel.org, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

On Fri, 2009-05-22 at 16:41 +0530, Kashyap, Desai wrote:
> @@ -4314,6 +4333,182 @@ mptsas_send_raid_event(struct fw_event_work *fw_event)
>  		mptsas_free_fw_event(ioc, fw_event);
>  }
>  
> +/**
> + *	mptsas_issue_tm - send mptsas internal tm request
> + *	@ioc: Pointer to MPT_ADAPTER structure
> + *	@type
> + *	@channel
> + *	@id
> + *	@lun
> + *	@task_context
> + *	@timeout
> + *
> + *	return:
> + *
> + **/

That's not really very descriptive, is it?

> +/**
> + * mptscsih_get_scsi_lookup
> + *
> + * retrieves scmd entry from ScsiLookup[] array list
> + *
> + * @ioc: Pointer to MPT_ADAPTER structure
> + * @i: index into the array
> + *
> + * Returns the scsi_cmd pointer
> + *
> + **/

This is nicely descriptive, but it isn't legal docbook.  That should be

/**
 * mptscsih_get_scsi_lookup - retrieve scmd entry from ScsiLookup[] array list
 * @ioc: Pointer to MPT_ADAPTER structure
 * @i: index into the array
etc...

Nor is this:

> +/**
> + *     mptsas_broadcast_primative_work - Work queue thread to handle
> + *     broadcast primitive events
> + *     @work: work queue payload containing info describing the event
> + *
> + **/

The initial description needs to be all on one line, not split across
two.

James



James


