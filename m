From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: Re: [LSF/MM TOPIC] [ATTEND] SR-IOV Management
Date: Thu, 15 Mar 2012 08:44:00 -0400
Message-ID: <alpine.WNT.2.00.1203150842030.5032@N5102REMCQXM4BS.qlogic.org>
References: <alpine.WNT.2.00.1201311356390.3392@N5102REMCQXM4BS.qlogic.org> <4F29058B.6020904@suse.de> <alpine.WNT.2.00.1203141337330.3968@N5102REMCQXM4BS.qlogic.org> <CAAsGZS6aQ2Gw+wzozCenOJ+sfhoz4R5B52h3v0GScnuEUFJNjg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="173809-5451-1331815442=:5032"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:36969
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759351Ab2COMoG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Mar 2012 08:44:06 -0400
In-Reply-To: <CAAsGZS6aQ2Gw+wzozCenOJ+sfhoz4R5B52h3v0GScnuEUFJNjg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: chetan loke <loke.chetan@gmail.com>
Cc: Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

--173809-5451-1331815442=:5032
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: quoted-printable



On Wed, 14 Mar 2012, chetan loke wrote:

> On Wed, Mar 14, 2012 at 2:07 PM, Chad Dupuis <chad.dupuis@qlogic.com> wro=
te:
>>
>>
>> On Wed, 1 Feb 2012, Hannes Reinecke wrote:
>>
>>> On 01/31/2012 08:02 PM, Chad Dupuis wrote:
>>>>
>>>> With more and more storage controller hardware supporting SR-IOV in
>>>> next
>>>> couple of years it seems to make sense at this point to discuss, from =
a
>>>> storage stack perspective, managing how we instantiate and manage
>>>> SR-IOV
>>>> virtual functions (VFs).  Currently for hardware that does support
>>>> SR-IOV,
>>>> the management of that functionality is managed entirely by the
>>>> hardware
>>>> device driver.  However, a more dynamic management to how VFs are
>>>> created
>>>> and destroyed (assuming the hardware supports it) may be more desirabl=
e
>>>> since the most common use case, assigning VFs to virtual guests, also
>>>> tends to be very dynamic and fluid.  We also need to consider how VFs
>>>> interact with complimentary technology such as NPIV in Fibre Channel.
>>>>
>>>> I'd like to propose that we discuss the following issues to see if a
>>>> consensus can be reached about how to deal with them:
>>>>
>>>> * VF instantiation
>>>> * VF/NPIV port pairing
>>>> * Namespace management
>>>> * LUN presentation
>>>>
>>> Actually, SR-IOV on FC should be easy to handle; it maps quite
>>> easily on NPIV (which probably was the intention :-).
>>
>>
>> I would bet it's not a coincidence ;-)  The question I had was do we
>> represent this relationship at the transport level, such as the FC
>> transport in this case, or do we let the low-leve driver take care of th=
e
>> mapping? In other words, do we have a low level driver create the vport =
when
>> it is instantiating a VF or do we add an option to say fc_vport_create s=
o
>> that a VF is created along with a vport.
>
> Chad - would we always need a vport-context if just a VF needs to be
> mapped to a guest and NPIV is not enabled?
>

I don't believe so though you would still need some mechanism for the VF
to address external devices.

>
> Chetan
>
>

This message and any attached documents contain information from QLogic Cor=
poration or its wholly-owned subsidiaries that may be confidential. If you =
are not the intended recipient, you may not read, copy, distribute, or use =
this information. If you have received this transmission in error, please n=
otify the sender immediately by reply e-mail and then delete this message.

--173809-5451-1331815442=:5032--
