From: Laurence Oberman <loberman@redhat.com>
Subject: Re: [PATCH] st: implement sysfs based tape statistics v2
Date: Thu, 5 Feb 2015 13:12:07 -0500 (EST)
Message-ID: <706497510.6018016.1423159927046.JavaMail.zimbra@redhat.com>
References: <DDB9C85B850785449757F9914A034FCB3BF288C6@G9W0766.americas.hpqcorp.net> <CAAzz28jJBpu_Uh7b7qOVWk10dS6Q3Ogm087UEW7H9fiTWWGhQQ@mail.gmail.com> <5B997489-2D5C-4F85-BAB8-317E62F694E5@kolumbus.fi> <995891679.6002631.1423158020737.JavaMail.zimbra@redhat.com> <E267A9CB-6A91-4DD6-9BEE-D0DC6C048B07@kolumbus.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx4-phx2.redhat.com ([209.132.183.25]:37430 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175AbbBESM1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Feb 2015 13:12:27 -0500
In-Reply-To: <E267A9CB-6A91-4DD6-9BEE-D0DC6C048B07@kolumbus.fi>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai =?utf-8?Q?M=C3=A4kisara_=28Kolumbus=29?= <kai.makisara@kolumbus.fi>
Cc: Laurence Oberman <oberman.l@gmail.com>, Shane M Seymour <shane.seymour@hp.com>, linux-scsi@vger.kernel.org, "James E.J. Bottomley (JBottomley@parallels.com)" <JBottomley@parallels.com>, jeffm@suse.com

----- Original Message -----
=46rom: "Kai M=C3=A4kisara (Kolumbus)" <kai.makisara@kolumbus.fi>
To: "Laurence Oberman" <loberman@redhat.com>
Cc: "Laurence Oberman" <oberman.l@gmail.com>, "Shane M Seymour" <shane.=
seymour@hp.com>, linux-scsi@vger.kernel.org, "James E.J. Bottomley (JBo=
ttomley@parallels.com)" <JBottomley@parallels.com>, jeffm@suse.com
Sent: Thursday, February 5, 2015 12:46:32 PM
Subject: Re: [PATCH] st: implement sysfs based tape statistics v2


> On 5.2.2015, at 19.40, Laurence Oberman <loberman@redhat.com> wrote:
>=20
> ----- Original Message -----
> From: "Kai M=C3=A4kisara (Kolumbus)" <kai.makisara@kolumbus.fi>
> To: "Laurence Oberman" <oberman.l@gmail.com>
> Cc: "Shane M Seymour" <shane.seymour@hp.com>, loberman@redhat.com, li=
nux-scsi@vger.kernel.org, "James E.J. Bottomley (JBottomley@parallels.c=
om)" <JBottomley@parallels.com>, jeffm@suse.com
> Sent: Thursday, February 5, 2015 12:03:29 PM
> Subject: Re: [PATCH] st: implement sysfs based tape statistics v2
>=20
>=20
>> On 2.2.2015, at 17.16, Laurence Oberman <oberman.l@gmail.com> wrote:
>>=20
>> I pulled this this morning and will be testing. The prior version wa=
s
>> stable for me on the upstream and RHEL 6.5 kernel without exhaustive
>> testing.
>> We also just received more requests to get this into RHEL from HP /
>> Red Hat customers.
>>=20
>> Kai, what are your thoughts. I realize this is a large amount of
>> additional code. I am not keen to create a driver just for stats as =
we
>> would have to keep the rest of the st driver changes always in sync.
>>=20
>=20
> I still think that the tape statistics should be exported like the st=
atistics of =E2=80=9Creal=E2=80=9D block devices, i.e., one sysfs file =
exporting on a single line the statistics that temporally belong togeth=
er. James rejected this approach. I am leaving the decision about this =
code to him. I will neither ack nor nak this code.
>=20
> Thanks,
> Kai
>=20
> Hello Kai,
>=20
> I missed the earlier conversations with James, I will go search for t=
hem.
> Do you mean add them so they are similar to the /proc/diskstats
>=20
> cat /proc/diskstats
> ..
>   8       0 sda 2258346 152801 291907067 5263795 388817 1518048 15013=
833 4542062 0 4794931 9803495
>   8       1 sda1 717 102 26154 1179 8 2 80 76 0 1172 1254
>   8       2 sda2 328 31 2872 1554 0 0 0 0 0 1554 1554
>   8       3 sda3 2195205 151617 290898283 5203627 355053 1518046 1500=
9528 4370598 0 4594137 9571937
>   8       4 sda4 61921 1050 978350 57218 18 0 4225 34 0 56384 57185
>  11       0 sr0 0 0 0 0 0 0 0 0 0 0 0
> ..
>=20
Not exactly. I mean the data exported in sysfs, for example:

> cat /sys/block/sda/sda1/stat
  159740     9006  5941506    64461   124724    55907 12772208  3598677=
        0   299875  3663235

Kai

Ok, Thanks, got it now. Let me circle back with Shane

Laurence Oberman
Red Hat Global Support Service
SEG Team
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
