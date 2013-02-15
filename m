From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] Use a more selective error recovery strategy based on
 device capabilities
Date: Fri, 15 Feb 2013 08:17:36 +0100
Message-ID: <511DE110.4040506@suse.de>
References: <511A87CA.5010901@tributary.com> <511B8FBF.9000705@suse.de> <511BB545.7060600@tributary.com> <12DB2383-B7CE-4DD4-BBAA-D6701271A6E6@cs.wisc.edu> <511D4FB5.708@tributary.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42233 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935345Ab3BOHRi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Feb 2013 02:17:38 -0500
In-Reply-To: <511D4FB5.708@tributary.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Linton <jlinton@tributary.com>
Cc: Michael Christie <michaelc@cs.wisc.edu>, Linux Scsi <linux-scsi@vger.kernel.org>, "Elliott, Robert (Server Storage)" <Elliott@hp.com>

On 02/14/2013 09:57 PM, Jeremy Linton wrote:
> On 2/13/2013 8:43 PM, Michael Christie wrote:
>> For the case where report supported TMFs is not supported can we jus=
t have the
 >> LLD return some new return code from the eh callback when it=20
gets FUNCTION_REJECTED.
 >> scsi-ml would then clear the eh_*_ok bit, so at least it would=20
not be called again..
>
>
> 	Hmm, that seems like a good idea. The question is, does propagating =
the flag
> change to all the devices on the I_T make sense?
>
Hmm. Again, I've yet to find a storage array which actually _does_=20
reject a TMF.
None of mine do, not even the latest and greatest NetApp Ontap=20
version ...

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
