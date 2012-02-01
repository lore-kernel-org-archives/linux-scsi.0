From: Hannes Reinecke <hare@suse.de>
Subject: Re: [LSF/MM TOPIC] [ATTEND] SR-IOV Management
Date: Wed, 01 Feb 2012 10:27:39 +0100
Message-ID: <4F29058B.6020904@suse.de>
References: <alpine.WNT.2.00.1201311356390.3392@N5102REMCQXM4BS.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50508 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753519Ab2BAJ1l (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Feb 2012 04:27:41 -0500
In-Reply-To: <alpine.WNT.2.00.1201311356390.3392@N5102REMCQXM4BS.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chad Dupuis <chad.dupuis@qlogic.com>
Cc: lsf-pc@lists.linux-foundation.org, linux-scsi@vger.kernel.org

On 01/31/2012 08:02 PM, Chad Dupuis wrote:
> With more and more storage controller hardware supporting SR-IOV in
> next
> couple of years it seems to make sense at this point to discuss, from=
 a
> storage stack perspective, managing how we instantiate and manage
> SR-IOV
> virtual functions (VFs).  Currently for hardware that does support
> SR-IOV,
> the management of that functionality is managed entirely by the
> hardware
> device driver.  However, a more dynamic management to how VFs are
> created
> and destroyed (assuming the hardware supports it) may be more desirab=
le
> since the most common use case, assigning VFs to virtual guests, also
> tends to be very dynamic and fluid.  We also need to consider how VFs
> interact with complimentary technology such as NPIV in Fibre Channel.
>=20
> I'd like to propose that we discuss the following issues to see if a
> consensus can be reached about how to deal with them:
>=20
> * VF instantiation
> * VF/NPIV port pairing
> * Namespace management
> * LUN presentation
>=20
Actually, SR-IOV on FC should be easy to handle; it maps quite
easily on NPIV (which probably was the intention :-).

However, for SAS things get really tricky, as we don't have virtual
SAS IDs. Some vendor was actually planning on doing ACLs in firmware
(shudder).

And then there is the pci-stub mess.

So yes, definitely something to discuss here.

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
