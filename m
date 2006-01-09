From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH] fc transport: new attributes for NPIV
Date: Mon, 09 Jan 2006 14:04:39 -0500
Message-ID: <43C2B3C7.4010506@emulex.com>
References: <OFE227A343.800436AC-ON412570ED.0055DD4F-412570ED.00560A75@de.ibm.com> <43BD574D.8040009@emulex.com> <20060109180513.GA4286@infradead.org>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:62923 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1750702AbWAITGB
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Jan 2006 14:06:01 -0500
In-Reply-To: <20060109180513.GA4286@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Andreas Herrmann <AHERRMAN@de.ibm.com>, James Bottomley <jejb@steeleye.com>, Linux SCSI <linux-scsi@vger.kernel.org>



Christoph Hellwig wrote:
> Actually I think even for Xen-like virtualization it makes most sense that
> most domains wouldn't see the Scsi_Host for the phyisical port so this solution
> looks most sane to me.  The long name for the physical names sounds fine to me
> as well, much better than un-understandable three-latter acronyms :)

So my grind is just with the "physical_port_xxx" reference. It's too logical
of a name for someone uninitiated with NPIV. How do they know the difference
between physical_port_name and port_name, especially where the predominance of
configs will always have the same values in both attributes ? Choosing
something "physical" always seem like a better choice.

I should have known better on the abbreviation.... :)

Having made this argument - I then said - why not use the name from the
standards, "permanent_port_xxx". But, when I look at this, it's not much 
different. Permanent vs Physical ? at least the abbreviation gave it some
separation. Bah Humbug. My preference is still "permanent" over "physical"
as it tracks the standards name.

-- james


