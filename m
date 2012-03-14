From: chetan loke <loke.chetan@gmail.com>
Subject: Re: [LSF/MM TOPIC] [ATTEND] SR-IOV Management
Date: Wed, 14 Mar 2012 14:48:37 -0400
Message-ID: <CAAsGZS6aQ2Gw+wzozCenOJ+sfhoz4R5B52h3v0GScnuEUFJNjg@mail.gmail.com>
References: <alpine.WNT.2.00.1201311356390.3392@N5102REMCQXM4BS.qlogic.org>
	<4F29058B.6020904@suse.de>
	<alpine.WNT.2.00.1203141337330.3968@N5102REMCQXM4BS.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pz0-f52.google.com ([209.85.210.52]:49093 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754940Ab2CNSsh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Mar 2012 14:48:37 -0400
Received: by dadp12 with SMTP id p12so3350752dad.11
        for <linux-scsi@vger.kernel.org>; Wed, 14 Mar 2012 11:48:37 -0700 (PDT)
In-Reply-To: <alpine.WNT.2.00.1203141337330.3968@N5102REMCQXM4BS.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chad Dupuis <chad.dupuis@qlogic.com>
Cc: Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Wed, Mar 14, 2012 at 2:07 PM, Chad Dupuis <chad.dupuis@qlogic.com> w=
rote:
>
>
> On Wed, 1 Feb 2012, Hannes Reinecke wrote:
>
>> On 01/31/2012 08:02 PM, Chad Dupuis wrote:
>>>
>>> With more and more storage controller hardware supporting SR-IOV in
>>> next
>>> couple of years it seems to make sense at this point to discuss, fr=
om a
>>> storage stack perspective, managing how we instantiate and manage
>>> SR-IOV
>>> virtual functions (VFs). =C2=A0Currently for hardware that does sup=
port
>>> SR-IOV,
>>> the management of that functionality is managed entirely by the
>>> hardware
>>> device driver. =C2=A0However, a more dynamic management to how VFs =
are
>>> created
>>> and destroyed (assuming the hardware supports it) may be more desir=
able
>>> since the most common use case, assigning VFs to virtual guests, al=
so
>>> tends to be very dynamic and fluid. =C2=A0We also need to consider =
how VFs
>>> interact with complimentary technology such as NPIV in Fibre Channe=
l.
>>>
>>> I'd like to propose that we discuss the following issues to see if =
a
>>> consensus can be reached about how to deal with them:
>>>
>>> * VF instantiation
>>> * VF/NPIV port pairing
>>> * Namespace management
>>> * LUN presentation
>>>
>> Actually, SR-IOV on FC should be easy to handle; it maps quite
>> easily on NPIV (which probably was the intention :-).
>
>
> I would bet it's not a coincidence ;-) =C2=A0The question I had was d=
o we
> represent this relationship at the transport level, such as the FC
> transport in this case, or do we let the low-leve driver take care of=
 the
> mapping? In other words, do we have a low level driver create the vpo=
rt when
> it is instantiating a VF or do we add an option to say fc_vport_creat=
e so
> that a VF is created along with a vport.

Chad - would we always need a vport-context if just a VF needs to be
mapped to a guest and NPIV is not enabled?


Chetan
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
