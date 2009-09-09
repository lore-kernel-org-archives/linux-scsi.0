From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] SCSI driver for VMware's virtual HBA - V4.
Date: Wed, 9 Sep 2009 19:08:54 -0400
Message-ID: <20090909230854.GA4495@infradead.org>
References: <1252458903.24914.73.camel@ank32.eng.vmware.com> <4AA8177A.2020606@codemonkey.ws> <1252533093.24633.40.camel@ank32.eng.vmware.com> <4AA8284A.3010908@codemonkey.ws>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54079 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617AbZIIXI7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Sep 2009 19:08:59 -0400
Content-Disposition: inline
In-Reply-To: <4AA8284A.3010908@codemonkey.ws>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: akataria@vmware.com, James Bottomley <James.Bottomley@suse.de>, Rolf Eike Beer <eike-kernel@sf-tec.de>, Brian King <brking@linux.vnet.ibm.com>, "Chetan.Loke@Emulex.Com" <Chetan.Loke@Emulex.Com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "pv-drivers@vmware.com" <pv-drivers@vmware.com>, virtualization <virtualization@lists.linux-foundation.org>

On Wed, Sep 09, 2009 at 05:12:26PM -0500, Anthony Liguori wrote:
> Alok Kataria wrote:
>> I see your point, but the ring logic or the ABI that we use to
>> communicate between the hypervisor and guest is not shared between our
>> storage and network drivers. As a result, I don't see any benefit of
>> separating out this ring handling mechanism, on the contrary it might
>> just add some overhead of translating between various layers for our
>> SCSI driver.
>>   
>
> But if you separate out the ring logic, it allows the scsi logic to be  
> shared by other paravirtual device drivers.  This is significant and  
> important from a Linux point of view.

As someone who has been hacking on a virtio scsi prototype I don't think
it's a good idea.  The vmware driver is a horrible design and I don't
think it should be merged.  Besides beeing a ugly driver and ABI we
really should not support this kind of closed protocol development.

