From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 3/5] lpfc 10.2.8001.0: Removed obsolete PCI IDs from the
 driver
Date: Fri, 23 May 2014 17:58:42 +0200
Message-ID: <537F7032.6060001@suse.de>
References: <1399910007.25346.10.camel@myfc17> <20140519171944.GC32250@infradead.org> <537A41E6.8010607@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34597 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753128AbaEWP6p (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 May 2014 11:58:45 -0400
In-Reply-To: <537A41E6.8010607@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.smart@emulex.com, Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

On 05/19/2014 07:39 PM, James Smart wrote:
> :)
>
> for those distros, that want to pull only upstream'd patches, and whe=
re
> customers expect someone to take phone calls on any hardware recogniz=
ed
> by the distro... the patch is to remove the hardware Emulex/the distr=
o
> won't answer any questions for anymore.
>
> true - the hardware, if you can find it lying around somewhere, may
> still function. It won't get firmware updates, nor any mindshare. I'm
> not sure where the policy is for upstream - is it truly once known, c=
an
> never be taken away ?
>
Problem is, no-one does.

But I've proposed a micro-conf at LPC in October to discuss exactly
this. You're welcomed to join :-)
It would be good to have a mechanism which would retain the=20
functionality, but at the same time indicating that for any errors
you might be on your own.

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
