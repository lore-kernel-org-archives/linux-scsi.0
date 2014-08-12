From: Alexander Gordeev <agordeev@redhat.com>
Subject: Re: [PATCH v2 RESEND 12/23] lpfc: Use pci_enable_msix_range()
 instead of pci_enable_msix()
Date: Tue, 12 Aug 2014 09:11:16 +0100
Message-ID: <20140812081115.GA1674@agordeev.usersys.redhat.com>
References: <cover.1405533479.git.agordeev@redhat.com>
 <ea1bf102a3ce0471996e2ddaaa498b088ac791c8.1405533479.git.agordeev@redhat.com>
 <20140726082227.GF21129@agordeev.usersys.redhat.com>
 <20140811080148.GG16504@dhcp-27-160.brq.redhat.com>
 <dfd59266-71ff-4112-8e11-835a08d7a94d@CMEXHTCAS2.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <dfd59266-71ff-4112-8e11-835a08d7a94d@CMEXHTCAS2.ad.emulex.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Smart <james.smart@emulex.com>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Aug 11, 2014 at 01:14:54PM -0400, James Smart wrote:
> Alexander,
> 
> I haven't looked too deeply, but it's clear it doesn't jive with what we've
> discussed in the past. Your original patches missed several other similar
> sections for revision. I had sent a revised set of patches.
> 
> I was also unclear as to the merge path the patches were taking, as it was
> mod'ing areas that have already changed in the scsi misc tree, but the misc
> tree didn' have the pci mods.  I take it this is heading to Christoph's tree
> ?  and that it has picked up the pci mods ?

James,

I lost the context and not sure what PCI modifications you are referring :(
I will send a patch that combines your version shortly.

Thanks!

> -- james s

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
