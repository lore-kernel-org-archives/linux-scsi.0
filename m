From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 6/9] snic:Add low level queuing interfaces
Date: Tue, 07 Apr 2015 08:38:43 +0200
Message-ID: <55237B73.7080702@suse.de>
References: <1426093299-4511-1-git-send-email-nmusini@cisco.com> <1426093299-4511-7-git-send-email-nmusini@cisco.com> <55129874.1010604@suse.de> <D142F680.1D3FD%nmusini@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43520 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752962AbbDGGip (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Apr 2015 02:38:45 -0400
In-Reply-To: <D142F680.1D3FD%nmusini@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Narsimhulu Musini (nmusini)" <nmusini@cisco.com>, "JBottomley@Parallels.com" <JBottomley@Parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "Sesidhar Baddela (sebaddel)" <sebaddel@cisco.com>

On 04/02/2015 10:13 AM, Narsimhulu Musini (nmusini) wrote:
> Hi Hannes,
>=20
> Thank you for reviewing the patch. Please find responses inline.
> I will incorporate the comments and suggestions in next patch submitt=
al.
>=20
>=20
> On 25/03/15 4:43 pm, "Hannes Reinecke" <hare@suse.de> wrote:
>=20
>> Hi Narsimhulu,
>>
>> On 03/11/2015 06:01 PM, Narsimhulu Musini wrote:
>>> These files contain low level queueing interfaces includes
>>> hardware queues, and management of hardware features.
>>>
>>> v2
>>> driver supports x86-64 arch, so removed cpu_to_XX API to maintain
>>> consistency.
>>>
>>> Signed-off-by: Narsimhulu Musini <nmusini@cisco.com>
>>> Signed-off-by: Sesidhar Baddela <sebaddel@cisco.com>
>>> ---
>> Please find some comments below.
>>
[ .. ]
>> That really looks like a 64bit structure read in as 32bit values ...
>> If so please use 64bit values here ...
> The structure members are aligned to hardware data, I would prefer to=
 keep
> it same.
>=20
I _know_ that they are aligned.
The point of my question was whether these values are _real_ 32-bit
values or rather 64-bit values with the top 32-bit masked off.

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
