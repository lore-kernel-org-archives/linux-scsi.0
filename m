From: Alok Kataria <akataria@vmware.com>
Subject: Re: [PATCH] SCSI driver for VMware's virtual HBA - V4.
Date: Thu, 10 Sep 2009 16:43:49 -0700
Message-ID: <1252626229.3899.65.camel@ank32.eng.vmware.com>
References: <1252458903.24914.73.camel@ank32.eng.vmware.com>
	 <4AA8177A.2020606@codemonkey.ws>
	 <1252533093.24633.40.camel@ank32.eng.vmware.com>
	 <4AA8284A.3010908@codemonkey.ws>  <20090909230854.GA4495@infradead.org>
Reply-To: akataria@vmware.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752570AbZIJXnu@vger.kernel.org>
In-Reply-To: <20090909230854.GA4495@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Anthony Liguori <anthony@codemonkey.ws>, James Bottomley <James.Bottomley@suse.de>, Rolf Eike Beer <eike-kernel@sf-tec.de>, Brian King <brking@linux.vnet.ibm.com>, "Chetan.Loke@Emulex.Com" <Chetan.Loke@Emulex.Com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "pv-drivers@vmware.com" <pv-drivers@vmware.com>, virtualization <virtualization@lists.linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

Hi Christoph, 

On Wed, 2009-09-09 at 16:08 -0700, Christoph Hellwig wrote:
> On Wed, Sep 09, 2009 at 05:12:26PM -0500, Anthony Liguori wrote:
> > Alok Kataria wrote:
> >> I see your point, but the ring logic or the ABI that we use to
> >> communicate between the hypervisor and guest is not shared between our
> >> storage and network drivers. As a result, I don't see any benefit of
> >> separating out this ring handling mechanism, on the contrary it might
> >> just add some overhead of translating between various layers for our
> >> SCSI driver.
> >>   
> >
> > But if you separate out the ring logic, it allows the scsi logic to be  
> > shared by other paravirtual device drivers.  This is significant and  
> > important from a Linux point of view.
> 
> As someone who has been hacking on a virtio scsi prototype I don't think
> it's a good idea.

Can I take a look at your work on virtio scsi ?

>   The vmware driver is a horrible design and I don't
> think it should be merged. 

Can you be more specific ? What problems do you see in the driver or the
ABI.

>  Besides beeing a ugly driver and ABI we
> really should not support this kind of closed protocol development.
> 

Alok
