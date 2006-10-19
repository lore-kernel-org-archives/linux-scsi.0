From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] ALUA support for scsi_debug
Date: Thu, 19 Oct 2006 09:08:11 +0200
Message-ID: <4537245B.5090806@suse.de>
References: <20061018145018.GC25084@pentland.suse.de> <4536602A.5050008@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58828 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S1946010AbWJSHIV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Oct 2006 03:08:21 -0400
In-Reply-To: <4536602A.5050008@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

Douglas Gilbert wrote:
> Hannes Reinecke wrote:
>> Hi all,
>>
>> I've hacked up scsi_debug to support REPORT TARGET PORT GROUPS.
>> In combination with vpd_use_hostno=3D0 it'll now support multipathin=
g
>> nicely.
>> Doug, there is reference to port_a and port_b in the VPD page suppor=
t.
>> However, port_b appearently is just a fake entry with no (virtual)
>> device backing.
>=20
> Hannes,
> Yes, I was mimicking a SAS drive with the secondary port
> unconnected.
>=20
Hmm. We could to that, too. Just set the secondary port to unavailable.
Let's see ...

>> We could eg use the 'channel' value to refer the relative port numbe=
r,
>> so that host & channel act as a fan-out for multipathing.
>=20
> I'll have a look, perhaps it could be wired when
> vpd_use_hostno=3D0 .
>=20
Yep, that would be possible.

>> James, please apply.
>=20
> Umm, I would like to find out why that patch oopses
> my machine when I load the scsi_debug module.
>=20
Not my fault (I hope). Patch works when compiling under 2.6.18 ...

Cheers,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
