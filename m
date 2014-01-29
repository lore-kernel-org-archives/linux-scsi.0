From: Alexander Gordeev <agordeev@redhat.com>
Subject: Re: [PATCH v2 4/9] ipr: Use pci_enable_msi_range() and
 pci_enable_msix_range()
Date: Wed, 29 Jan 2014 14:26:52 +0100
Message-ID: <20140129132651.GA27764@dhcp-26-207.brq.redhat.com>
References: <cover.1389904166.git.agordeev@redhat.com>
 <eb0b62be65c050533f2565fcf3f1d673770dfd67.1389904166.git.agordeev@redhat.com>
 <20140128095441.GA6951@dhcp-26-207.brq.redhat.com>
 <52E7CCAD.5070008@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <52E7CCAD.5070008@linux.vnet.ibm.com>
Sender: kvm-owner@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, kvm@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, Wendy Xiong <wenxiong@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jan 28, 2014 at 09:28:45AM -0600, Brian King wrote:

Thanks for the review, Brian!

> These look like they will conflict with a recent patch to
> the ipr driver:
> 
> http://www.spinics.net/lists/linux-scsi/msg71644.html

BTW, this one does not appear ACKed.

> Do you want me to rediff your patches on top of this one,
> or do you want to keep the entire MSI series together
> and do the rediff? Otherwise the patches seem fine.

I would prefer the former.

@Bjorn, please let us know if you prefer otherwise.

> Thanks,
> 
> Brian
> 
> 
> -- 
> Brian King
> Power Linux I/O
> IBM Linux Technology Center
> 
> 

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
