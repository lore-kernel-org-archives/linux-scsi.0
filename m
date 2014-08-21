From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 11/13] lpfc: Use pci_enable_msix_range() instead of
 pci_enable_msix()
Date: Thu, 21 Aug 2014 10:02:13 -0700
Message-ID: <20140821170213.GA2296@infradead.org>
References: <cover.1408335523.git.agordeev@redhat.com>
 <e7470e484083c9eeb6b4f34f3e69e332ad5998c2.1408335523.git.agordeev@redhat.com>
 <53F5D8DF.4060705@redhat.com>
 <53F5DEEF.4070406@redhat.com>
 <20140821165833.GA5853@agordeev.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140821165833.GA5853@agordeev.usersys.redhat.com>
Sender: linux-pci-owner@vger.kernel.org
To: Alexander Gordeev <agordeev@redhat.com>
Cc: Tomas Henzl <thenzl@redhat.com>, Christoph Hellwig <hch@infradead.org>, James Smart <james.smart@emulex.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Aug 21, 2014 at 05:58:34PM +0100, Alexander Gordeev wrote:
> > Reviewed-by: Tomas Henzl
> 
> Christoph, this patch was declined by James few times.
> I think it needs his approval as well.

You're referring to James Smart here, right?  For an actively maintained
driver like lpfc I'd like it be acked by the maintainer indeed.  In fact
for lpfc I have an agreement with James that he'll pick up lpfc patches 
and sent the colleted patches on to me.
