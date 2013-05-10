From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi: Allow error handling timeout to be specified
Date: Fri, 10 May 2013 14:55:31 +0200
Message-ID: <518CEE43.2050505@suse.de>
References: <yq1fvxvedg6.fsf@sermon.lab.mkp.net> <1368189791.3319.31.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53211 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751216Ab3EJMzd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 May 2013 08:55:33 -0400
In-Reply-To: <1368189791.3319.31.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: emilne@redhat.com
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu

On 05/10/2013 02:43 PM, Ewan Milne wrote:
> On Thu, 2013-05-09 at 23:11 -0400, Martin K. Petersen wrote:
>> Introduce eh_timeout which can be used for error handling purposes. =
This
>> was previously hardcoded to 10 seconds in the SCSI error handling
>> code. However, for some fast-fail scenarios it is necessary to be ab=
le
>> to tune this as it can take several iterations (bus device, target, =
bus,
>> controller) before we give up.
>>
>> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
>>
>=20
> Thanks for posting this.  It will be very helpful to have this
> capability, particularly when alternate paths to the device exist.
>=20
> Acked-by: Ewan D. Milne <emilne@redhat.com>
>=20
>=20
Seconded.

Acked-by: Hannes Reinecke <hare@suse.de>

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
