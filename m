From: Hannes Reinecke <hare@suse.de>
Subject: Re: [Scst-devel] Fwd: Re: linuxcon 2010...
Date: Tue, 07 Sep 2010 08:29:29 +0200
Message-ID: <4C85DBC9.6030601@suse.de>
References: <1283204792.32007.448.camel@haakon2.linux-iscsi.org>	<4C7FFD1A.8090509@vlnb.net>	<1283459158.5598.143.camel@haakon2.linux-iscsi.org>	<20100905201802.GC18411@core.coreip.homeip.net>	<1283723447.556.133.camel@haakon2.linux-iscsi.org>	<20100905234134.GA17212@core.coreip.homeip.net>	<1283731194.556.147.camel@haakon2.linux-iscsi.org>	<1283769578.15944.1293.camel@mulgrave.site>	<4C85617E.2080603@vlnb.net>	<1283810135.556.238.camel@haakon2.linux-iscsi.org>	<20100907004424.GB21430@core.coreip.homeip.net> <AANLkTin9Hk8+oMdXfB4h_DhirRyPf00739g5BpKcUE_5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46881 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752460Ab0IGG3a (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Sep 2010 02:29:30 -0400
In-Reply-To: <AANLkTin9Hk8+oMdXfB4h_DhirRyPf00739g5BpKcUE_5@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>

Bart Van Assche wrote:
> On Tue, Sep 7, 2010 at 2:44 AM, Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
>> [ ... ]
>>
>> Vlad appears to be asserting that SCST is more feature-complete that=
 LIO
>> at this point. It also seems that LIO is somewhat younger than SCST.=
 So
>> at this point it might be interesting to see:
>>
>> 1. What are the shortcomings of SCST design compared to LIO and why =
LIO
>> developers chose to come with their own solution instead of
>> collaborating with SCST folks?
>>
>> 2. What features are missing from SCST that are currently available =
in
>> LIO?
>>
>> Once this is sorted out and [most] everyone agrees that LIO is indee=
d
>> technically superior (even if maybe not as mature yet) solution, the=
n it
>> would make sense to request SCST developers to go to file/line depth=
 of
>> the review.
>=20
> You seem to have missed the start of this thread. The design of SCST
> is significantly more advanced than that of LIO, and it has already
> been explained in this thread why
> (http://www.spinics.net/lists/linux-scsi/msg45856.html).
>=20
Hmm. That link seems to be misrouted. I was hoping for a design
overview of SCST there; however it's just a complain to
James Bottomley etc.

Care to send the correct link?

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
