From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 11/13] lpfc: Use pci_enable_msix_range() instead of
 pci_enable_msix()
Date: Thu, 4 Sep 2014 08:11:03 -0700
Message-ID: <20140904151103.GA9093@infradead.org>
References: <cover.1408335523.git.agordeev@redhat.com>
 <e7470e484083c9eeb6b4f34f3e69e332ad5998c2.1408335523.git.agordeev@redhat.com>
 <20140904132939.GA1225@agordeev.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140904132939.GA1225@agordeev.usersys.redhat.com>
Sender: linux-pci-owner@vger.kernel.org
To: Alexander Gordeev <agordeev@redhat.com>
Cc: James Smart <james.smart@emulex.com>, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Sep 04, 2014 at 02:29:39PM +0100, Alexander Gordeev wrote:
> On Mon, Aug 18, 2014 at 08:01:51AM +0200, Alexander Gordeev wrote:
> > As result of deprecation of MSI-X/MSI enablement functions
> > pci_enable_msix() and pci_enable_msi_block() all drivers
> > using these two interfaces need to be updated to use the
> > new pci_enable_msi_range()  or pci_enable_msi_exact()
> > and pci_enable_msix_range() or pci_enable_msix_exact()
> > interfaces.
> 
> James?

It's part of the lpfc update he recently sent out.  It's high up on my
list of things to review.
