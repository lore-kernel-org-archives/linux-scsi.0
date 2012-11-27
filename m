From: Hannes Reinecke <hare@suse.de>
Subject: Re: SCSI LLDs, the SCSI error handler and host resource lifetime
Date: Tue, 27 Nov 2012 16:37:09 +0100
Message-ID: <50B4DE25.30206@suse.de>
References: <50AB9286.8040403@acm.org> <50AC808D.1060700@suse.de> <50B3A59F.3050506@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53841 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754981Ab2K0PhL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Nov 2012 10:37:11 -0500
In-Reply-To: <50B3A59F.3050506@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On 11/26/2012 06:23 PM, Bart Van Assche wrote:
> On 11/21/12 08:19, Hannes Reinecke wrote:
>> Hmm.
>> This would still mean that the eh thread will run until finished.
>> Which can take _A LOT_ of time (we're speaking hours here).
>> I would rather have an additional return code in the various
>> scsi_try_XXX functions to terminate the loop quickly.
>
> Hello Hannes,
>
> Since I'm not sure that I understood you properly: is something like
> the patch below what you had in mind ?
>
Yeah, something like this.
Although the usage of 'scsi_host_scan_allowed()' is
non-obvious; after all, we're not _scanning_ this host,
we're just checking if it's working normally.

But thanks for doing this.
Cheers,

Hannes

--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
