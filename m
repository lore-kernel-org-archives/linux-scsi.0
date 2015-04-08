From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 6/9] snic:Add low level queuing interfaces
Date: Wed, 08 Apr 2015 11:07:03 +0200
Message-ID: <5524EFB7.2030307@suse.de>
References: <1426093299-4511-1-git-send-email-nmusini@cisco.com> <1426093299-4511-7-git-send-email-nmusini@cisco.com> <55129874.1010604@suse.de> <D142F680.1D3FD%nmusini@cisco.com> <55237B73.7080702@suse.de> <D14AEBAA.1FFDB%nmusini@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45118 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751933AbbDHJHF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Apr 2015 05:07:05 -0400
In-Reply-To: <D14AEBAA.1FFDB%nmusini@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Narsimhulu Musini (nmusini)" <nmusini@cisco.com>, "JBottomley@Parallels.com" <JBottomley@Parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "Sesidhar Baddela (sebaddel)" <sebaddel@cisco.com>

On 04/08/2015 11:05 AM, Narsimhulu Musini (nmusini) wrote:
> Hi Hannes,
>=20
>   Thank you for reviewing patches. Please find responses inline.
>=20
>=20
> On 07/04/15 12:08 pm, "Hannes Reinecke" <hare@suse.de> wrote:
>=20
>> On 04/02/2015 10:13 AM, Narsimhulu Musini (nmusini) wrote:
>>> Hi Hannes,
>>>
>>> Thank you for reviewing the patch. Please find responses inline.
>>> I will incorporate the comments and suggestions in next patch submi=
ttal.
>>>
>>>
>>> On 25/03/15 4:43 pm, "Hannes Reinecke" <hare@suse.de> wrote:
>>>
>>>> Hi Narsimhulu,
>>>>
>>>> On 03/11/2015 06:01 PM, Narsimhulu Musini wrote:
>>>>> These files contain low level queueing interfaces includes
>>>>> hardware queues, and management of hardware features.
>>>>>
>>>>> v2
>>>>> driver supports x86-64 arch, so removed cpu_to_XX API to maintain
>>>>> consistency.
>>>>>
>>>>> Signed-off-by: Narsimhulu Musini <nmusini@cisco.com>
>>>>> Signed-off-by: Sesidhar Baddela <sebaddel@cisco.com>
>>>>> ---
>>>> Please find some comments below.
>>>>
>> [ .. ]
>>>> That really looks like a 64bit structure read in as 32bit values .=
=2E.
>>>> If so please use 64bit values here ...
>>> The structure members are aligned to hardware data, I would prefer =
to
>>> keep
>>> it same.
>>>
>> I _know_ that they are aligned.
>> The point of my question was whether these values are _real_ 32-bit
>> values or rather 64-bit values with the top 32-bit masked off.
> They are real 32 bit values. These are registers, falling on 64 bit
> boundaries.
Right, that's okay then.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
