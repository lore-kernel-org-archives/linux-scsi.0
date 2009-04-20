From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH] ipr: ipr_remove() marked __devexit
Date: Mon, 20 Apr 2009 09:23:06 -0500
Message-ID: <49EC854A.2020900@linux.vnet.ibm.com>
References: <1237839145.13011.54.camel@zeppelin.austin.ibm.com> <1239995314.6143.1.camel@zeppelin.austin.ibm.com> <1240020307.5763.1.camel@mulgrave> <1240235787.7458.13.camel@zeppelin.austin.ibm.com> <1240237018.3315.14.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:45045 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756023AbZDTOXm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Apr 2009 10:23:42 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e32.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id n3KEKbt6003768
	for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2009 08:20:37 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n3KENQF8012456
	for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2009 08:23:26 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n3KENMRA032582
	for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2009 08:23:25 -0600
In-Reply-To: <1240237018.3315.14.camel@mulgrave.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Kleber S. Souza" <klebers@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> On Mon, 2009-04-20 at 10:56 -0300, Kleber S. Souza wrote:
>> On Fri, 2009-04-17 at 22:05 -0400, James Bottomley wrote:
>>> On Fri, 2009-04-17 at 16:08 -0300, Kleber S. Souza wrote:
>>>> Hi,
>>>>
>>>> Any comments on this patch?=20
>>>>
>>>> It was acked by Brian King, do I need to do anything else to get i=
t
>>>> accepted?
>>> No ... looks OK to me:
>>>
>>>> Thanks,
>>>> Kleber
>>>>
>>>> On Mon, 2009-03-23 at 17:12 -0300, Kleber Sacilotto de Souza wrote=
:
>>>>> Marking the ipr clean up function ipr_remove() as __devexit and u=
sing
>>>>> __devexit_p() macro in its address reference.
>>>>>
>>>>>
>>>>> Signed-off-by: Kleber Sacilotto de Souza <kleber@linux.vnet.ibm.c=
om>
>>>>> Signed-off-by: Breno Leitao <leitao@linux.vnet.ibm.com>
>>> Just explain this signoff?  signed-off-by is supposed to document t=
he
>>> hands the patch has passed through ... it's not clear what Breno Le=
itao
>>> has to do with the transmission of this patch.
>>>
>> Breno Leit=C3=A3o pointed out to me that this change needed to be ma=
de based
>> on the kernel documentation <Documentation/PCI/pci.txt>. I wrote the
>> patch, got the ack from Brian King and sent it to the list.
>=20
> So that should be Reported-by: not Signed-off-by for Breno.
>=20
> There's no actual ack from Brian King on this email.

Acked by: Brian King <brking@linux.vnet.ibm.com>

--=20
Brian King
Linux on Power Virtualization
IBM Linux Technology Center


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
