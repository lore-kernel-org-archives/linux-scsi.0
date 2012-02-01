From: Hannes Reinecke <hare@suse.de>
Subject: Re: GRUB doesn't like ServeRAID M1015/LSI 9220-8i (was Re: mvsas
 with 3.1)
Date: Wed, 01 Feb 2012 16:16:57 +0100
Message-ID: <4F295769.6070003@suse.de>
References: <201201131144.58044.thomas@fjellstrom.ca> <201202010703.09833.thomas@fjellstrom.ca> <4F294E64.10204@anonymous.org.uk> <201202010742.07818.thomas@fjellstrom.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201202010742.07818.thomas@fjellstrom.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: thomas@fjellstrom.ca
Cc: John Robinson <john.robinson@anonymous.org.uk>, linux-raid <linux-raid@vger.kernel.org>, linux-kernel@vger.kernel.org, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 02/01/2012 03:42 PM, Thomas Fjellstrom wrote:
> On Wed Feb 1, 2012, John Robinson wrote:
>> On 01/02/2012 14:03, Thomas Fjellstrom wrote:
>> [...]
>>
>>>  I picked up a refurb IBM
>>>
>>> ServeRaid M1015 (aka: LSI 9220-8i) card. It arrived yesterday. Just=
 have
>>> to wait and see why grub doesn't like it.
>>
>> When you find out, please let me know - I bought one via ebay, its
>> firmware was elderly and wouldn't let me put it in JBOD mode, after =
a
>> bit of googling I flashed it with IBM's latest firmware, then GRUB
>> thought my machine had no RAM in it. The card has been sitting in a =
box
>> since.
>=20
> Yeah, GRUB immediately throws an "out of memory. Aborted" error, its =
annoying,=20
> but I reported the issue on GRUB's bug tracker after talking to a guy=
 in #grub=20
> on freenode. Hopefully someone looks at it soon. It appears it happen=
s so=20
> early in grub's startup that it can't even output any debug info (I w=
as asked=20
> to run: `grub-install --debug-image=3Dall /dev/sdX`, and did so, I ge=
t debug=20
> output when the card is not installed, but absolutely nothing when it=
 is=20
> installed.
>=20
=46rom my experience the BIOS wouldn't present any disks in JBOD mode.
So you'd be needing to switch to RAID mode first.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
