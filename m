From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 5/5] SCSI/initio conversion to PCI driver API
Date: Sun, 27 May 2007 11:45:37 -0400
Message-ID: <4659A7A1.2070100@garzik.org>
References: <20070527145200.GA17017@havoc.gtf.org>	 <20070527145955.GE17085@havoc.gtf.org>  <46599DD9.4020408@garzik.org> <1180278739.3711.16.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:40249 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754723AbXE0Ppk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 May 2007 11:45:40 -0400
In-Reply-To: <1180278739.3711.16.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>

James Bottomley wrote:
> On Sun, 2007-05-27 at 11:03 -0400, Jeff Garzik wrote:
>> Jeff Garzik wrote:
>>> Prior simplifications in this patchset now permit a minimal conversion
>>> to the new PCI API.
>>>
>>> Further improvements and simplifications are certainly possible; those
>>> should be presented in a separate patchset.
>>>
>>> DO NOT APPLY (yet).  For feedback (and testers?) only.
>>
>> This only applies to patch #5.
>>
>> Patches 1 through 4 should go upstream, IMO.
> 
> Erm, actually, you're treading all over Alan:
> 
> http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commit;h=72d39fea9017bbb1407620bf89dfe8d1fb658e35
> 
> Could you rebase your patches to scsi-misc-2.6 and resubmit (if there's
> anything Alan hasn't covered)?


Hey, if it's tested at least minimally that's the minimum I hoped to 
achieve.  It sounds like you can drop all patches, though if it takes 
forever for scsi-misc-2.6 to go upstream, users in the interim will be 
denied the make-it-actually-work fix provided in patch #1, if that matters.

	Jeff


