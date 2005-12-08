From: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: RFC: ACPI/scsi/libata integration and hotswap
Date: Thu, 8 Dec 2005 13:39:45 +0000
Message-ID: <20051208133945.GA21633@srcf.ucam.org>
References: <20051208030242.GA19923@srcf.ucam.org> <20051208091542.GA9538@infradead.org> <20051208132657.GA21529@srcf.ucam.org> <20051208133308.GA13267@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932086AbVLHNju@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20051208133308.GA13267@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, randy_d_dunlap@linux.intel.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, acpi-devel@lists.sourceforge.net
List-Id: linux-scsi@vger.kernel.org

On Thu, Dec 08, 2005 at 01:33:08PM +0000, Christoph Hellwig wrote:

> Don't do it at all.  We don't need to fuck up every layer and driver for
> intels braindamage.

Doing SATA suspend/resume properly on x86 depends on knowing the ACPI 
object that corresponds to a host or target. It's also the only way to 
support hotswap on this hardware[1], since there's no way for userspace 
to know which device a notification refers to.

[1] ie, most laptops sold nowadays
-- 
Matthew Garrett | mjg59@srcf.ucam.org
