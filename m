From: =?ISO-8859-1?Q?Rog=E9rio_Brito?= <rbrito@ime.usp.br>
Subject: Re: changes to ieee1394/sbp2 outside of linux1394.org
Date: Sun, 17 Jul 2005 21:14:05 -0300
Message-ID: <42DAF44D.2040500@ime.usp.br>
References: <20050715005309.GB14816@ime.usp.br> <20050715014312.GI13229@phunnypharm.org> <20050715155332.GA3954@ime.usp.br> <20050715172854.GJ13229@phunnypharm.org> <20050715185034.GA3903@ime.usp.br> <20050715205741.GN13229@phunnypharm.org> <20050716014225.GA9733@ime.usp.br> <20050716155637.GA22044@phunnypharm.org> <20050716164202.GA3846@ime.usp.br> <20050717165712.GA7883@phunnypharm.org> <20050717191832.GB15629@ime.usp.br> <42DAB58F.4000801@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtpout1.uol.com.br ([200.221.4.192]:38599 "EHLO
	smtp.uol.com.br") by vger.kernel.org with ESMTP id S261281AbVGQVOP
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 17 Jul 2005 17:14:15 -0400
In-Reply-To: <42DAB58F.4000801@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-scsi@vger.kernel.org, linux1394-devel@lists.sourceforge.net, Ben Collins <bcollins@debian.org>

Stefan Richter wrote:
> Rog=E9rio Brito wrote:
>=20
>> On Jul 17 2005, Ben Collins wrote:
>>
>>> That's exactly what we were expecting. The hotplug scripts don't
>>> recognize TYEP_RBC just yet, but that will be resolved soon.
>>
>>
>> Oh, right. I can test any further changes that you might have, then.
>=20
>=20
> But didn't you add type 14 (RBC disk) and its association with sd_mod
> to your distro's scsi.agent script already...?

Yes, I did. I'm using a patched scsi.agent as per your recommendation. =
I=20
just thought that, perhaps, Ben had another change in mind.

But if that is all that has to be changed, then, there must be somethin=
g=20
incomplete somewhere, because, even though, sd_mod is associated with=20
type 14 in scsi.agent, I had to load it manually to make it work with=20
the linux1394 trunk. :-(

Of course, as you may expect, loading sd_mod manually is not the only=20
way to get the firewire disk working. I have a small USB pen-drive (tha=
t=20
I use for saving critical data) and plugging it automatically loads sd_=
mod.

If I, then, plug the firewire enclosure, then everything works as=20
expected (as sd_mod is already loaded).

I am now slightly puzzled. BTW, I'm using Debian testing as my=20
distribution, just as some extra information.


Thank you very much, Rog=E9rio.

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
