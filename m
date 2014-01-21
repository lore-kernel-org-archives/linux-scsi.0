From: Hannes Reinecke <hare@suse.de>
Subject: Re: [LSF/MM TOPIC] [ATTEND] scsi_eh updates
Date: Tue, 21 Jan 2014 07:52:50 +0100
Message-ID: <52DE1942.3090908@suse.de>
References: <D63B9804CB63AD4FAAD9660376956646470290B2@avmb2.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37585 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750934AbaAUGwv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Jan 2014 01:52:51 -0500
In-Reply-To: <D63B9804CB63AD4FAAD9660376956646470290B2@avmb2.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Giridhar Malavali <giridhar.malavali@qlogic.com>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On 01/20/2014 07:44 PM, Giridhar Malavali wrote:
>=20
>=20
> On 12/20/13 6:54 AM, "Hannes Reinecke" <hare@suse.de> wrote:
>=20
[ .. ]
>>
>> As discussed during last year's LSF the SCSI error handler should be
>> updated to handle modern SCSI transports better.
>> While some patchsets are already merged, there are some issues which
>> are still open:
>> - Handling of requests during host reset:
>>  Do we need to keep hold of outstanding requests during host reset?
>>  Or is it save to return them prior to host reset?
>> - Check for transport status prior to sending TMFs.
>>  Task management functions typically need a working I_T nexus,
>>  so it does make sense to first check the transport status
>>  prior to attempting any TMFs
>> - Further steps for updating SCSI EH
>> As these are tricky issues which have possible repercussions on the
>> entire subsystem and LLDDs it'd be good to have a broader discussion
>> here.
>=20
> +1
>=20
> I would like to participate in this discussion to provide inputs from
> LLDDs.
>=20
And I would _very_ much like to have participation from LLDD
vendors/providers; as part of the scsi_eh update I plan to introduce
a new callback 'eh_transport_reset'.
Which need to be implemented at the LLDD level.

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
