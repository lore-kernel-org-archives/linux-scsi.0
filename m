From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: SCSI QLA not working on latest *-mm SN2
Date: Wed, 22 Sep 2004 01:03:19 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.60.0409220016250.5562@poirot.grange>
References: <20040917183029.GW642@parcelfarce.linux.theplanet.co.uk>
 <200409201540.02297.jbarnes@engr.sgi.com> <20040920232716.GD19511@colo.lackof.org>
 <200409201709.45008.jbarnes@engr.sgi.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.de ([213.165.64.20]:42632 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S267362AbUIUXEK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Sep 2004 19:04:10 -0400
In-Reply-To: <200409201709.45008.jbarnes@engr.sgi.com>
List-Id: linux-scsi@vger.kernel.org
To: Jesse Barnes <jbarnes@engr.sgi.com>
Cc: Grant Grundler <grundler@parisc-linux.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, pj@sgi.com, linux-scsi@vger.kernel.org, mdr@cthulhu.engr.sgi.com, jeremy@cthulhu.engr.sgi.com, djh@cthulhu.engr.sgi.com, Andrew Morton <akpm@osdl.org>

On Mon, 20 Sep 2004, Jesse Barnes wrote:

> On Monday, September 20, 2004 4:27 pm, Grant Grundler wrote:
>> I understand "write posting" as when the CPU posts the write
>> to the chipset and the chipset says the write is done even though
>> it hasn't reached the PCI device. It just means the write has reached
>> the PCI "domain" (which is supposed to be strongly ordered).
>
> That's my understanding too.

It might be OT for this specific discussion - but ("for completeness") - I 
think, there are PCI host-controllers that implement _only_ PCI-to-host 
post-write and read FIFOs (buffers)... Example - IT8152.

Regards
Guennadi
---
Guennadi Liakhovetski

