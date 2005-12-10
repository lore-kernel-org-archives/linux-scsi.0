From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: RFC: ACPI/scsi/libata integration and hotswap
Date: Fri, 09 Dec 2005 19:40:08 -0500
Message-ID: <439A23E8.3080407@pobox.com>
References: <20051208141811.GB21715@srcf.ucam.org> <1134052433.17102.17.camel@localhost.localdomain> <20051208145257.GB21946@srcf.ucam.org> <20051208171901.GA22451@srcf.ucam.org> <20051209114246.GB16945@infradead.org> <20051209114944.GA1068@havoc.gtf.org> <20051209115235.GB25771@srcf.ucam.org> <43997171.9060105@pobox.com> <20051209121124.GA25974@srcf.ucam.org> <439975AB.5000902@pobox.com> <20051209122457.GB26070@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932688AbVLJAkZ@vger.kernel.org>
In-Reply-To: <20051209122457.GB26070@srcf.ucam.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Christoph Hellwig <hch@infradead.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>, randy_d_dunlap@linux.intel.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, acpi-devel@lists.sourceforge.net
List-Id: linux-scsi@vger.kernel.org

Matthew Garrett wrote:
> On Fri, Dec 09, 2005 at 07:16:43AM -0500, Jeff Garzik wrote:
> 
> 
>>libata will immediately notice the ejection without ACPI's help.
> 
> 
> http://linux.yyz.us/sata/sata-status.html claims that ICH6 doesn't 
> support hotswap. The Intel docs seem to say the same thing. Pulling the 
> drive out generates an ACPI interrupt but not a PCI one. I'm really 
> happy to be wrong here, it's just that everything I've been able to find 
> so far suggests that ACPI is the only way to get a notification that the 
> drive has gone missing :)

ICH6 and ICH7 support it just fine, through the normal SATA PHY 
registers.  ICH5 only support it if you are clever :)

Further, although one can detect hot-unplug on ICH5, hotplug is probably 
not detectable without polling or SMI.

	Jeff
