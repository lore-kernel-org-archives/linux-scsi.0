From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Some parisc updates for SCSI
Date: Thu, 6 Mar 2003 15:52:37 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030306155237.A11888@infradead.org>
References: <20030306154048.D1549@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030306154048.D1549@parcelfarce.linux.theplanet.co.uk>; from willy@debian.org on Thu, Mar 06, 2003 at 03:40:48PM +0000
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: linux-scsi@vger.kernel.org

On Thu, Mar 06, 2003 at 03:40:48PM +0000, Matthew Wilcox wrote:
> 
> The config stanza for SCSI_ZALON was in the wrong place, so move it.
> Make SCSI_NCR53C8XX conflict with SCSI_ZALON.
> Give ncr53c8xx and sym53c8xx names
> Fill in detach and release methods unconditionally.
> Call pci_set_master() in sym53c8xx.
> Both these drivers need interrupt.h, not sched.h

Please also initialize the host template directly in the c file instead
of those ugly 2.2-area macros..

