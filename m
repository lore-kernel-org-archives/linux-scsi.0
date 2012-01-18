From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 0/7] acpi/libata: Express dependencies for devices on
 dock stations and bays
Date: Wed, 18 Jan 2012 01:42:37 -0500
Message-ID: <4F1669DD.8030107@garzik.org>
References: <20111206163718.GA3629@homac.suse.de> <20120105103651.GB13066@homac.suse.de> <4F165B59.8050609@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <4F165B59.8050609@kernel.org>
Sender: linux-acpi-owner@vger.kernel.org
To: Len Brown <lenb@kernel.org>
Cc: Holger Macht <holger@homac.de>, Jeff Garzik <jgarzik@redhat.com>, linux-acpi@vger.kernel.org, linux-scsi@vger.kernel.org, Matthew Garrett <mjg@redhat.com>, Shaohua Li <shaohua.li@intel.com>, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 01/18/2012 12:40 AM, Len Brown wrote:
> Nice to see this effort.  I hadn't noticed it before.
> This is mostly an ATA patch, and so I would hope to see
> Tejun review it and Jeff Garzik ship it in his ata tree.
>
> I don't see any problem w/ the ACPI bits.

That sounds like an ACK from ACPI to me...  Will queue and push via 
libata-dev, assuming there are no cross-tree conflicts/dependencies with 
acpi in linux-next.

	Jeff


