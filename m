From: Jean Delvare <jdelvare@suse.de>
Subject: RE: megaraid_sas: "FW in FAULT state!!", how to get more debug
 output? [BKO63661]
Date: Mon, 29 Jun 2015 15:25:20 +0200
Message-ID: <1435584320.4646.53.camel@chaos.site>
References: <robbat2-20140712T111727-002806026Z@orbis-terrarum.net>
	 <CAErSpo5+=33byGqCjFCSfTpfKFtSAHRqYLzGF7yf5d18gEmWsQ@mail.gmail.com>
	 <robbat2-20140712T215640-831385120Z@orbis-terrarum.net>
	 <20150429172832.GB7888@google.com> <20150528122443.GI10210@google.com>
	 <9e8b957da24d7b1f532ed83ffb86ca37@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55088 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752896AbbF2NZY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Jun 2015 09:25:24 -0400
In-Reply-To: <9e8b957da24d7b1f532ed83ffb86ca37@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kashyap Desai <kashyap.desai@avagotech.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, "Robin H. Johnson" <robbat2@gentoo.org>, Adam Radford <aradford@gmail.com>, Neela Syam Kolli <megaraidlinux@lsi.com>, linux-scsi@vger.kernel.org, arkadiusz.bubala@open-e.com, Matthew Garrett <matthew.garrett@nebula.com>, Sumit Saxena <sumit.saxena@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>, "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@avagotech.com>, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, Myron Stowe <myron.stowe@redhat.com>

Hi Kashyap,

Thanks for the patch. May I ask what tree it was based on? Linus'
latest? I am trying to apply it to the SLES 11 SP3 and SLES 12 kernel
trees (based on kernel v3.0 + a bunch of backports and v3.12
respectively) but your patch fails to apply in both cases. I'll try
harder but I don't know anything about the megaraid_sas code so I reall=
y
don't know where I'm going.

Does your patch depend on any other that may not be present in the SLES
11 SP3 and SLES 12 kernels?

Thanks,
Jean

Le Thursday 28 May 2015 =C3=A0 19:05 +0530, Kashyap Desai a =C3=A9crit =
:
> Bjorn/Robin,
>=20
> Apologies for delay. Here is one quick suggestion as we have seen sim=
ilar
> issue (not exactly similar, but high probably to have same issue) whi=
le
> controller is configured on VM as pass-through and VM reboot abruptly=
=2E
> In that particular issue, driver interact with FW which may  require =
chip
> reset to bring controller to operation state.
>=20
> Relevant patch was submitted for only Older controller as it was only=
 seen
> for few MegaRaid controller. Below patch already try to do chip reset=
, but
> only for limited controllers...I have attached one more patch which d=
oes
> chip reset from driver load time for Thunderbolt/Invader/Fury etc. (I=
n
> your case you have Thunderbolt controller, so attached patch is requi=
red.)
>=20
> http://www.spinics.net/lists/linux-scsi/msg67288.html
>=20
> Please post the result with attached patch.
>=20
> Thanks, Kashyap


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
