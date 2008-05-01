From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [PATCH 0/4] Use of new scsi_allocate_command
Date: Thu, 01 May 2008 10:47:18 -0500
Message-ID: <1209656838.3067.16.camel@localhost.localdomain>
References: <4819C9DB.60104@panasas.com>
	 <1209651854.3067.8.camel@localhost.localdomain>
	 <4819DA39.70505@panasas.com>
	 <1209655360.3067.14.camel@localhost.localdomain>
	 <4819E371.2040403@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4819E371.2040403-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Cc: Matthew Dharm <mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2008-05-01 at 18:36 +0300, Boaz Harrosh wrote:
> On Thu, May 01 2008 at 18:22 +0300, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org> wrote:
> > On Thu, 2008-05-01 at 17:56 +0300, Boaz Harrosh wrote:
> >> The call to pci_map_page() on an ISA case will it not bounce the
> >> buffer?
> > 
> > Only if the system isn't a PCI_DMA_BUS_IS_PHYS one.
> > 
> > That means basically either has an iommu/gart or has some silly swiotlb
> > to emulate one.
> > 
> > That means for standard x86 isa systems the answer is no: the buffer has
> > to be allocated within the isa region because pci_map is simply a
> > virt_to_phys.
> > 
> > James
> > 
> OK Thanks, so the second patch then. That will solve it.

Um, your second patch is only changing isd200; it's hard to see how that
can fix a gdth problem ...

James


--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
