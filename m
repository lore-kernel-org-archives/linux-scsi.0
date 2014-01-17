From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/1] scsi: hpsa, add all PCI ID's that HP has in svn
Date: Fri, 17 Jan 2014 16:31:07 +0100
Message-ID: <52D94CBB.5020701@suse.de>
References: <20140116195112.GA9658@beardog.cce.hp.com> <52D948A5.1070706@redhat.com> <48275AD710FCA34184C2B6186B4016B32D1A0B01@G6W2491.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39219 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753240AbaAQPbK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Jan 2014 10:31:10 -0500
In-Reply-To: <48275AD710FCA34184C2B6186B4016B32D1A0B01@G6W2491.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Cc: Tomas Henzl <thenzl@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, "James E. J. Bottomley" <James.Bottomley@HansenPartnership.com>, LKML <linux-kernel@vger.kernel.org>, LKML-scsi <linux-scsi@vger.kernel.org>, "Stephen M. Cameron" <scameron@beardog.cce.hp.com>

On 01/17/2014 04:17 PM, Miller, Mike (OS Dev) wrote:
>=20
>=20
>> -----Original Message-----
>> From: Tomas Henzl [mailto:thenzl@redhat.com]
>> Sent: Friday, January 17, 2014 9:14 AM
>> To: Miller, Mike (OS Dev); Andrew Morton; James E. J. Bottomley
>> Cc: LKML; LKML-scsi; hare@suse.de; Stephen M. Cameron
>> Subject: Re: [PATCH 1/1] scsi: hpsa, add all PCI ID's that HP has in=
 svn
>>
>> On 01/16/2014 08:51 PM, Mike Miller wrote:
>>> From: Mike Miller <mike.miller@hp.com>
>>>
>>> This patch has every ID we have in our svn repository. Some
>>> controllers were cancelled, others added, now the cancelled ones ar=
e
>>> back. Apparently the debate rages on about which controllers are
>>> cancelled, which are not, whatever. Please accept this patch. It is
>>> dependent upon the patches I sent yesterday.
>>> This patch made/tested against kernel-3.13.0-rc8
>>>
>>> Signed-off-by: Mike Miller <mike.miller@hp.com>
>>> ---
>>>  drivers/scsi/hpsa.c |   12 ++++++++++++
>>>  1 files changed, 12 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c index
>>> 348b207..3affec5 100644
>>> --- a/drivers/scsi/hpsa.c
>>> +++ b/drivers/scsi/hpsa.c
>>> @@ -100,6 +100,7 @@ static const struct pci_device_id
>> hpsa_pci_device_id[] =3D {
>>>  	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C,
>> 0x3354},
>>>  	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C,
>> 0x3355},
>>>  	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C,
>> 0x3356},
>>> +	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C,
>> 0x1920},
>>>  	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C,
>> 0x1921},
>>>  	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C,
>> 0x1922},
>>>  	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C,
>> 0x1923},
>>> @@ -108,15 +109,19 @@ static const struct pci_device_id
>> hpsa_pci_device_id[] =3D {
>>>  	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C,
>> 0x1926},
>>>  	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C,
>> 0x1928},
>>>  	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C,
>> 0x1929},
>>> +	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C,
>> 0x192A},
>>>  	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C,
>> 0x21BD},
>>>  	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C,
>> 0x21BE},
>>>  	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C,
>> 0x21BF},
>>>  	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C,
>> 0x21C0},
>>>  	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C,
>> 0x21C2},
>>>  	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C,
>> 0x21C3},
>>> +	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C,
>> 0x21C4},
>>>  	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C,
>> 0x21C5},
>>> +	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C,
>> 0x21C6},
>>>  	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C,
>> 0x21C7},
>>>  	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C,
>> 0x21C8},
>>> +	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C,
>> 0x21C9},
>>>  	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C,
>> 0x21CA},
>>>  	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C,
>> 0x21CB},
>>>  	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C,
>> 0x21CC},
>>> @@ -149,22 +154,29 @@ static struct board_type products[] =3D {
>>>  	{0x3354103C, "Smart Array P420i", &SA5_access},
>>>  	{0x3355103C, "Smart Array P220i", &SA5_access},
>>>  	{0x3356103C, "Smart Array P721m", &SA5_access},
>>> +	{0x1920103C, "Smart Array P430i", &SA5_access},
>>>  	{0x1921103C, "Smart Array P830i", &SA5_access},
>>>  	{0x1922103C, "Smart Array P430", &SA5_access},
>>>  	{0x1923103C, "Smart Array P431", &SA5_access},
>>>  	{0x1924103C, "Smart Array P830", &SA5_access},
>>> +	{0x1925103C, "Smart Array P831", &SA5_access},
>>>  	{0x1926103C, "Smart Array P731m", &SA5_access},
>>>  	{0x1928103C, "Smart Array P230i", &SA5_access},
>>>  	{0x1929103C, "Smart Array P530", &SA5_access},
>>> +	{0x192A103C, "Smart Array P531", &SA5_access},
>>>  	{0x21BD103C, "Smart Array", &SA5_access},
>>>  	{0x21BE103C, "Smart Array", &SA5_access},
>>>  	{0x21BF103C, "Smart Array", &SA5_access},
>>>  	{0x21C0103C, "Smart Array", &SA5_access},
>>> +	{0x21C1103C, "Smart Array", &SA5_access},
>>
>> I think that both tables should be in sync - but there is no 0x21c1 =
in
>> hpsa_pci_device_id (and the 0x1925), could you clarify that?
>>
>> Thanks, Tomas
>=20
> Crap. It seems like these menial tasks get the better of me. I'll cor=
rect and resubmit.
>=20
Hmm. Seeing that hpsa is now well capable of supporting even older
SmartArray controllers, is there really a point in updating the
PCI-ID list every time?
Wouldn't you be better off by just using the catch-all phrase
and remove all the individual IDs?

That way you would just have to update _one_ list ...

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
