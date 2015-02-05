From: =?utf-8?Q?=22Kai_M=C3=A4kisara_=28Kolumbus=29=22?=
	<kai.makisara@kolumbus.fi>
Subject: Re: [PATCH] st: implement sysfs based tape statistics v2
Date: Thu, 5 Feb 2015 19:03:29 +0200
Message-ID: <5B997489-2D5C-4F85-BAB8-317E62F694E5@kolumbus.fi>
References: <DDB9C85B850785449757F9914A034FCB3BF288C6@G9W0766.americas.hpqcorp.net> <CAAzz28jJBpu_Uh7b7qOVWk10dS6Q3Ogm087UEW7H9fiTWWGhQQ@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2070.6\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vs19.mail.saunalahti.fi ([62.142.117.200]:36428 "EHLO
	vs19.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965030AbbBERPN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Feb 2015 12:15:13 -0500
In-Reply-To: <CAAzz28jJBpu_Uh7b7qOVWk10dS6Q3Ogm087UEW7H9fiTWWGhQQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Laurence Oberman <oberman.l@gmail.com>
Cc: "Seymour, Shane M" <shane.seymour@hp.com>, "loberman@redhat.com" <loberman@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E.J. Bottomley (JBottomley@parallels.com)" <JBottomley@parallels.com>, "jeffm@suse.com" <jeffm@suse.com>


> On 2.2.2015, at 17.16, Laurence Oberman <oberman.l@gmail.com> wrote:
>=20
> I pulled this this morning and will be testing. The prior version was
> stable for me on the upstream and RHEL 6.5 kernel without exhaustive
> testing.
> We also just received more requests to get this into RHEL from HP /
> Red Hat customers.
>=20
> Kai, what are your thoughts. I realize this is a large amount of
> additional code. I am not keen to create a driver just for stats as w=
e
> would have to keep the rest of the st driver changes always in sync.
>=20

I still think that the tape statistics should be exported like the stat=
istics of =E2=80=9Creal=E2=80=9D block devices, i.e., one sysfs file ex=
porting on a single line the statistics that temporally belong together=
=2E James rejected this approach. I am leaving the decision about this =
code to him. I will neither ack nor nak this code.

Thanks,
Kai

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
