From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH 2.6.13 14/14] sas-class: SCSI Host glue
Date: Mon, 12 Sep 2005 13:12:03 -0400
Message-ID: <4325B6E3.9090503@adaptec.com>
References: <20050910041218.29183.qmail@web51612.mail.yahoo.com>	 <Pine.LNX.4.63.0509101028510.4630@cuia.boston.redhat.com>	 <20050911035621.87661.qmail@mail.muc.de> <1126446071.4831.5.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:44236 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S932067AbVILRM0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Sep 2005 13:12:26 -0400
In-Reply-To: <1126446071.4831.5.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: ak@muc.de, Rik van Riel <riel@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On 09/11/05 09:41, James Bottomley wrote:
> On Sun, 2005-09-11 at 05:56 +0200, ak@muc.de wrote:
> 
>>>>Naturally, aic94xx has _no limitations_. :-)  But hey, our hardware just 
>>>>kicks a*s!
>>>
>>>That's very nice for you - but lets face it, a SAS layer
>>>that'll be unable to also deal with the El-Cheapo brand
>>>controllers isn't going to be very useful.
>>
>>Nobody knows what these bu^wlimitations will be though. So you cannot
>>really plan for them in advance.  When someone writes drivers for such 
>>limited hardware they can add code to handle the limitations. But it 
>>seems reasonable to start with a clean hardware model, and only
>>add the hacks later when they are really needed and the requirements
>>are understood.
> 
> 
> But my point was that we already have a mechanism for coping with this:
> The scsi template parameterises some of these things (max sector size,
> sg table elements, clustering, etc).

James, people have _already_ replied to your point, saying
that they want to start with a _clean_ hardware model/interface.
See Alan and Andi's emails.

I don't know why do you keep grinding this, just like the
IDR thread (you had no other code to write?) and like the
"EH turned into ACA" thread?

It is time SCSI Core started cleanly, especially now with SAS
which will completely *replace* Parallel SCSI and IDE (for SATA).

> For less standard things it
> doesn't cover the driver uses the blk_ adjustors directly from
> slave_alloc/slave_configure (This is currently how USB and firewire
> communicate their alignment requirements).
> 
> By wrappering both the template and the slave_alloc/slave_configure
> methods in the SAS class and not providing the driver access, it can't
> use existing methods to make any adjustments that may be necessary.

"that may be necessary"?

You don't listen to anyone, do you?

Let's deal with those when they come.  The sas_ha_struct can certainly
deal with those as I pointed out in a previous email in this thread:
http://marc.theaimsgroup.com/?l=linux-scsi&m=112632556516797&w=2

We do not want to write code for things "that may be necessary".
This has been pointed out numerous times.

	Luben

