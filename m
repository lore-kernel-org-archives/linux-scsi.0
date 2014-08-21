From: Alexander Gordeev <agordeev@redhat.com>
Subject: Re: [PATCH v3 11/13] lpfc: Use pci_enable_msix_range() instead of
 pci_enable_msix()
Date: Thu, 21 Aug 2014 17:58:34 +0100
Message-ID: <20140821165833.GA5853@agordeev.usersys.redhat.com>
References: <cover.1408335523.git.agordeev@redhat.com>
 <e7470e484083c9eeb6b4f34f3e69e332ad5998c2.1408335523.git.agordeev@redhat.com>
 <53F5D8DF.4060705@redhat.com>
 <53F5DEEF.4070406@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <53F5DEEF.4070406@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>, Christoph Hellwig <hch@infradead.org>, James Smart <james.smart@emulex.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Aug 21, 2014 at 01:58:39PM +0200, Tomas Henzl wrote:
> my bad, this was already fixed in
> commit 029165acfa611a3a8838723f6978586ae35ff53d lpfc: Remove superfluous call to pci_disable_msix()
> 
> so patch looks good to me now

Many thanks for your reviews, Tomas!

> Reviewed-by: Tomas Henzl

Christoph, this patch was declined by James few times.
I think it needs his approval as well.

James?

Thanks!

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
