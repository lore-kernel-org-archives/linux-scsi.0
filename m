From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] sd: Reshuffle init_sd to avoid crash
Date: Wed, 10 Oct 2012 12:01:09 +0200
Message-ID: <50754765.8040304@suse.de>
References: <1349858171-29358-1-git-send-email-hare@suse.de> <1349862941.2452.11.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57283 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753886Ab2JJKBN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Oct 2012 06:01:13 -0400
In-Reply-To: <1349862941.2452.11.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, "Joel D. Diaz" <joeldiaz@us.ibm.com>

On 10/10/2012 11:55 AM, James Bottomley wrote:
> On Wed, 2012-10-10 at 10:36 +0200, Hannes Reinecke wrote:
>> scsi_register_driver will register a prep_fn() function, which
>> in turn migh need to use the sd_cdp_pool for DIF.
>> Which hasn't been initialised at this point, leading to
>> a crash. So reshuffle the init_sd() and exit_sd() paths
>> to have the driver registered last.
>>
>> Signed-off-by: Joel D. Diaz <joeldiaz@us.ibm.com>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>
> Explain what these signoffs mean, since the patch is sent with you as
> the author.
>
Ah. Sorry.
Joel Diaz send the patch relative to SLES11 SP2, and I ported / send=20
it to mainline.

So yeah, Joel is actually the author.
Should I send an updated patch?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
