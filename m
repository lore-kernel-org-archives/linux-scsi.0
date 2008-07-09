From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 0/2] scsi_dh patchset fixes
Date: Wed, 09 Jul 2008 09:17:57 +0200
Message-ID: <48746625.7090604@suse.de>
References: <486E2986.6090209@suse.de> <1215183959.5413.10.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.suse.de ([195.135.220.2]:39799 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752018AbYGIHR7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Jul 2008 03:17:59 -0400
In-Reply-To: <1215183959.5413.10.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Hi James,

James Bottomley wrote:
> On Fri, 2008-07-04 at 15:45 +0200, Hannes Reinecke wrote:
>> Hi James,
>>
>> these patches just fix the suggestions made by you and Mike C.
>> - Check the return code from try_module_get()
>> - Use GFP_ATOMIC in the IO path
>=20
> I thought the final agreement was that these should be GFP_NOIO?
>=20
Ok, will do so.

>> Patches apply on top of my previous patchset for the scsi_dh fixes.
>=20
> Could you not do this?  The GFP_KERNEL will spit might sleep warnings=
 on
> certain configs and the try_module_get could cause an oops on removal=
=2E
> Either of these might confuse a bisection search if it accidentally
> landed in them.  In general, for unapplied patches with identified bu=
gs,
> the patches should be fixed before applying.
>=20
Whatever you say :-)
I'll redo the patchset.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
