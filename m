From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi: delete decade+ obsolete aic7xxx_old driver
Date: Tue, 17 Sep 2013 16:29:04 +0200
Message-ID: <52386730.4060508@suse.de>
References: <y687fpks4kdsmfuadq4cykip.1379384036544@email.android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57816 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752270Ab3IQO3J (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Sep 2013 10:29:09 -0400
In-Reply-To: <y687fpks4kdsmfuadq4cykip.1379384036544@email.android.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>, linux-scsi list <linux-scsi@vger.kernel.org>, linux-kernel@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>

On 09/17/2013 04:13 AM, Doug Ledford wrote:
> Yes, this driver is well past ready to be removed.
>=20
> Acked-by: Doug Ledford <dledford@redhat.com>
>=20
> Sent from my ASUS Pad
>=20
> Paul Gortmaker <paul.gortmaker@windriver.com> wrote:
>=20
>> After getting warnings in an allyesconfig build[1] from this
>> driver, I decided to remind myself just how old it was, and
>> whether it warranted fixing.  In the Kconfig help text, I found:
>>
>>  "This driver will eventually be phased out entirely"
>>
>> Going back to the history archive, I see the line was added[2]
>> in Feb 2002, when we moved from v2.4.2.1 ---> v2.4.2.2
>>
>> So, with over a decade of notification, and multiple major releases
>> since then, I think we can justify removing this.  Currently we have
>> people wasting time building it during routine testing, and then
>> wasting more time re-researching the known reported warnings, only t=
o
>> find that nobody really is willing to integrate the fixes[3] for it.
>>
>> A quick search didn't seem to indicate any active user base for it.
>> If someone happens to have a quirky _old_ card that the eleven year
>> old "new" driver doesn't work with, then it is entirely reasonable
>> that they stick with a kernel version that predates this removal.
>>
>> [1] drivers/scsi/aic7xxx_old.c: In function =E2=80=98aic7xxx_registe=
r=E2=80=99:
>>    drivers/scsi/aic7xxx_old.c:7901:5: warning: case value =E2=80=982=
57=E2=80=99 not in enumerated type =E2=80=98ahc_chip=E2=80=99 [-Wswitch=
]
>>    drivers/scsi/aic7xxx_old.c:7898:5: warning: case value =E2=80=985=
13=E2=80=99 not in enumerated type =E2=80=98ahc_chip=E2=80=99 [-Wswitch=
]
>>    drivers/scsi/aic7xxx_old.c: In function =E2=80=98aic7xxx_load_see=
prom=E2=80=99:
>>    drivers/scsi/aic7xxx_old.c:8517:5: warning: case value =E2=80=982=
57=E2=80=99 not in enumerated type =E2=80=98ahc_chip=E2=80=99 [-Wswitch=
]
>>    drivers/scsi/aic7xxx_old.c:8510:5: warning: case value =E2=80=985=
13=E2=80=99 not in enumerated type =E2=80=98ahc_chip=E2=80=99 [-Wswitch=
]
>>
>> [2] http://git.kernel.org/cgit/linux/kernel/git/tglx/history.git com=
mit 44e8778c
>>
>> [3] https://lkml.org/lkml/2012/10/29/215
>>
>> Cc: Hannes Reinecke <hare@suse.de>
>> Cc: Doug Ledford <dledford@redhat.com>
>> Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
>> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

However, if we do this we're removing support for any non-PCI based
adapters. I personally doubt that there are any installations left
running on (E)ISA or VLB. But we should be clear on this.

In general I'm in favour removing obsolete drivers, so

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
