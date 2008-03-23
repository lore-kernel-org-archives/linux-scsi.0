From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: ultrastor.c is a bit-rot
Date: Sun, 23 Mar 2008 09:24:03 -0700
Message-ID: <47E68423.2010507@zytor.com>
References: <47DE8736.8020405@panasas.com> <20080317152344.GE26285@parisc-linux.org> <47E41D7D.9050409@zytor.com> <47E628DF.6070301@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:41180 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846AbYCWQ3Q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Mar 2008 12:29:16 -0400
In-Reply-To: <47E628DF.6070301@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Matthew Wilcox <matthew@wil.cx>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel <linux-kernel@vger.kernel.org>

Boaz Harrosh wrote:
> On Fri, Mar 21 2008 at 22:41 +0200, "H. Peter Anvin" <hpa@zytor.com> wrote:
>> Matthew Wilcox wrote:
>>> VESA Local Bus.  It was (in some sense) the predecessor of AGP.  We
>>> treat it like ISA inside the kernel.  On x86, EISA depends on ISA, so
>>> the dependency, while wrong, does not affect any x86 users who have an
>>> EISA card.
>>>
>> Well, one can say VLB was to ISA (a souped-up ISA bus with some of the 
>> worst limitations removed) what AGP is to PCI...
>>
>> 	-hpa
> 
> Hmm interesting, so someone took the VGA thing and made a storage device
> for it. Did that ever happen with AGP? Any AGP scsi cards. I guess I can
> Google for it.

A lot less likely, IMO.  Unlike AGP-PCI, VLB slots were compatible with 
ISA cards, and the electricals were less complex, so several motherboard 
manufacturers built boards with 3 or more VESA slots (I think I saw a 
board with 6 at one point.)

AGP electricals pretty much require that it be point to point.

	-hpa
