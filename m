From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH 2.6.13 2/14] sas-class: README
Date: Tue, 13 Sep 2005 09:20:06 -0400
Message-ID: <4326D206.4050100@adaptec.com>
References: <4321E4DD.7070405@adaptec.com> <43238C16.4010709@torque.net> <4325B333.3070301@adaptec.com> <43269A7A.3080602@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:21914 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S964771AbVIMNUN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Sep 2005 09:20:13 -0400
In-Reply-To: <43269A7A.3080602@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On 09/13/05 05:23, Douglas Gilbert wrote:
> Luben Tuikov wrote:
>>The questiong is _what_ to do on this event.  This is a complex
>>answer and I'd rather have a _SES_ layer (or at least a logical
>>module/library) to handle those as storage vendors want this,
>>_right now_.
> 
> 
> Simple answer: generate a hotplug event and let a
> user application that cares worry about it. No
> need for a SES layer in the kernel.

Well, that sounds ok, but it maybe the case that the SES
device wants to say something about the SAS devices
on the same level.  So even if userspace gets it, it would
have nothing to do with it, because of the _type_ of SES
device/event/etc.
(User space can be notified anyway, which is perfectly fine).

>>In fact, I've some patches to submit regarding SES devices
>>on the domain, but I wanted to _trim *down*_ the politics,
>>_not_ escalate them.
> 
> 
> Oh no, not a sysfs representation of SES abstractions :-)

No, not that.

	Luben

