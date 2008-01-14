From: Hans de Goede <j.w.r.degoede@hhs.nl>
Subject: Re: PATCH: usb-storage-psc1350-v4.patch (was Linux scsi /	usb-mass-storage
 and HP printer cardreader bug + fix)
Date: Mon, 14 Jan 2008 20:10:59 +0100
Message-ID: <478BB3C3.3070101__13890.8639237799$1200337854$gmane$org@hhs.nl>
References: <47854051.1060307@hhs.nl> <4785F6CD.6050907@panasas.com> <4785F908.3080307@hhs.nl> <47860106.3090509@panasas.com> <4787CE08.5000304@hhs.nl> <1200303645.11301.15.camel@littletux> <478B2F90.7010105@hhs.nl> <20080114160310.GH14375@one-eyed-alien.net> <1200328388.3159.20.camel@localhost.localdomain> <20080114190105.GJ14375@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp3.versatel.nl ([62.58.50.90]:43004 "EHLO smtp3.versatel.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753872AbYANTJm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Jan 2008 14:09:42 -0500
In-Reply-To: <20080114190105.GJ14375@one-eyed-alien.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Hans de Goede <j.w.r.degoede@hhs.nl>, Guillaume Bedot <littletux@zarb.org>, Boaz Harrosh <bharrosh@panasas.com>, USB

Matthew Dharm wrote:
> On Mon, Jan 14, 2008 at 10:33:08AM -0600, James Bottomley wrote:
>> On Mon, 2008-01-14 at 08:03 -0800, Matthew Dharm wrote:
>>> We may be able to convince the SCSI people to enable it for all devices,
>>> regardless of HCD.
>> No ... I'm not particularly keen to have enterprise vendors after my
>> blood ...
> 
> Fair enough.  Tho, we should probably just enable this blindly for all
> usb-storage devices.  Otherwise, this is just going to become an
> unusual_devs.h nightmare.
> 

Since this will make all devices with this bug "just work" (tm), I'm all for it!

As soon as I get an answer from the scsi people on my questions resulting from 
there review I'll do a new patch for the scsi layer for this.

Regards,

Hans

