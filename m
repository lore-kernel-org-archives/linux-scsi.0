From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] declare and export scsi_bus_type
Date: Thu, 12 Dec 2002 07:58:01 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200212121358.gBCDw2b01977@localhost.localdomain>
References: <hch@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id FAA02538
	for <linux-scsi@vger.kernel.org>; Thu, 12 Dec 2002 05:58:07 -0800
In-Reply-To: Message from Christoph Hellwig <hch@infradead.org>
   of "Thu, 12 Dec 2002 09:12:03 GMT." <20021212091203.A21539@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Matt Domsch <Matt_Domsch@Dell.com>, linux-scsi@vger.kernel.org, mochel@osdl.org

hch@infradead.org said:
> I'm very unhappy with exporting random parts of the scsi midlayer.  In
> what way do you need it?  How does your code work with modular scsi? 

Convention tends to be that these bus types are exported.  That's certainly 
true for pci and mca.

However, perhaps we should have a better way of finding them than by direct 
export of the symbol.  Since each bus is required to have a unique name, and 
the sysfs system has an internal list of bus_types, we could have a function 
which takes the name and returns a pointer to the bus_type if it exists?

James


