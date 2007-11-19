From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] debloat aic7xxx and aic79xx drivers
Date: Mon, 19 Nov 2007 08:19:42 +0100
Message-ID: <4741390E.3030402@suse.de>
References: <20071113031553.3c7b5c16.akpm@linux-foundation.org> <473AF9A5.50707@suse.de> <200711141439.58200.vda.linux@googlemail.com> <200711182051.00069.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:36297 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752362AbXKSHTn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Nov 2007 02:19:43 -0500
In-Reply-To: <200711182051.00069.vda.linux@googlemail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org

Denys Vlasenko wrote:
> Hi Matthew, Hannes,
>=20
> Any news on this? Where these patches stand now?
> Are they accepted into linux-scsi?
>=20
> On Wednesday 14 November 2007 13:39, Denys Vlasenko wrote:
>> hi Matthew,
>>
>> On Wednesday 14 November 2007 06:35, Hannes Reinecke wrote:
>>> Matthew Wilcox wrote:
>>>> On Wed, Nov 14, 2007 at 12:46:20AM -0700, Denys Vlasenko wrote:
>>>>> Finally they replied and asked to rediff it against their
>>>>> git tree. I did that and sent patches back. No reply since then.
>>>>>
>>>>> And mind you, the patch is not trying to do anything
>>>>> complex, it mostly moves code around, removes 'inline',
>>>>> adds 'const'. What should I think about it?
>>>> I'm waiting for an ACK/NAK from Hannes, the maintainer.  What shou=
ld I
>>>> do?
>> You could have informed me about this, and I would talk to Hannes
>> myself. This would free up your mind from keeping track of this
>> particular patch.
>> Parallelize development, prevent things from being forgotten.
>>
>>
>> Hi Hannes,
>>
>>> I haven't actually been able to test it here (too busy, sorry). If
>>> someone else confirms it does it's job then
>>>
>>> Acked-by: Hannes Reinecke <hare@suse.de>
>> It's not in my mailbox on this machine, gladly we have lkml archived
>> in the Net. Here is a positive tester report:
>>
>> http://lkml.org/lkml/2007/10/15/168:
>>
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> Date	Mon, 15 Oct 2007 15:53:08 +0200
>> From	Gabriel C <>
>> Subject	Re: [PATCH 0/3] debloat aic7xxx and aic79xx drivers
>>
>>>> Compile tested and applies cleanly to 2.6.23.
>>>> I don't have this hardware anymore and cannot run test these patch=
es.
>>> I can test these patches on an aic7892 controller later on today if=
 you
>> want.
>>
>> Works fine for me tested on :
>>
>> 03:0e.0 SCSI storage controller [0100]: Adaptec AIC-7892P U160/m
>> [9005:008f] (rev 02)
>>
>> Gabriel
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
As it's been tested, you have my

Acked-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
