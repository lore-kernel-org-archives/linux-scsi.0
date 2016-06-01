From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/5] scsi: Use pci_(request|release)_mem_regions
Date: Wed, 1 Jun 2016 00:59:29 -0700
Message-ID: <20160601075929.GC11923@infradead.org>
References: <cover.1464694724.git.jthumshirn@suse.de>
 <1123377cf09b08091957c7d1f58be1601dbfb50c.1464694724.git.jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1123377cf09b08091957c7d1f58be1601dbfb50c.1464694724.git.jthumshirn@suse.de>
Sender: linux-pci-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, James Smart <james.smart@avagotech.com>, Dick Kennedy <dick.kennedy@avagotech.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, May 31, 2016 at 02:05:11PM +0200, Johannes Thumshirn wrote:
> Now that we do have pci_request_mem_regions() and pci_release_mem_regions() at
> hand, use it in the lpfc driver.

This should read lpfc instead of scsi in the subject line.

Also the request side of the patch seems to be missing.
