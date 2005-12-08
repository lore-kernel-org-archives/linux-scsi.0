From: Christoph Hellwig <hch@infradead.org>
Subject: Re: RFC: ACPI/scsi/libata integration and hotswap
Date: Thu, 8 Dec 2005 09:15:42 +0000
Message-ID: <20051208091542.GA9538@infradead.org>
References: <20051208030242.GA19923@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1750859AbVLHJPs@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20051208030242.GA19923@srcf.ucam.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: randy_d_dunlap@linux.intel.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, acpi-devel@lists.sourceforge.net
List-Id: linux-scsi@vger.kernel.org

On Thu, Dec 08, 2005 at 03:02:42AM +0000, Matthew Garrett wrote:
> Hi!
> 
> The included patch does three things:
> 
> 1) It adds basic support for binding SCSI and SATA devices to ACPI 
> device handles. At the moment this is limited to hosts, and in practice 
> it's probably limited to SATA ones (ACPI doesn't spec how SCSI devices 
> should appear in the DSDT, so I'm guessing that in general they don't). 
> Given a host, you can DEVICE_ACPI_HANDLE(dev) it to get the handle to 
> the ACPI device - this should be handy for implementing suspend 
> functions, since the methods should be in a standard location underneath 
> this.


NACK.  ACPI-specific hacks do not have any business at all in the scsi layer.
