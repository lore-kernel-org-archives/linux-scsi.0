From: Alexander Gordeev <agordeev@redhat.com>
Subject: Re: [PATCH v2 4/9] ipr: Use pci_enable_msi_range() and
 pci_enable_msix_range()
Date: Mon, 24 Feb 2014 09:12:09 +0100
Message-ID: <20140224081209.GA32200@dhcp-26-207.brq.redhat.com>
References: <cover.1389904166.git.agordeev@redhat.com>
 <eb0b62be65c050533f2565fcf3f1d673770dfd67.1389904166.git.agordeev@redhat.com>
 <20140128095441.GA6951@dhcp-26-207.brq.redhat.com>
 <52E7CCAD.5070008@linux.vnet.ibm.com>
 <20140129132651.GA27764@dhcp-26-207.brq.redhat.com>
 <20140130140630.GA32349@dhcp-26-207.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140130140630.GA32349@dhcp-26-207.brq.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>, James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, Wendy Xiong <wenxiong@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jan 30, 2014 at 03:06:30PM +0100, Alexander Gordeev wrote:
> On Wed, Jan 29, 2014 at 02:26:52PM +0100, Alexander Gordeev wrote:
> > > Do you want me to rediff your patches on top of this one,
> > > or do you want to keep the entire MSI series together
> > > and do the rediff? Otherwise the patches seem fine.
> > 
> > I would prefer the former.
> 
> Hi Brian,
> 
> I am sending the refreshed patches on top of "ipr: Handle early EEH".

Hi Brian,

What three the two patches you ACKed are against?
Should I ask James to take them?

Thanks!

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
