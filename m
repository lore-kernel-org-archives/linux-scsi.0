From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH 0/2] Remove support for deprecated %pf and %pF in vsprintf
Date: Sun, 24 Mar 2019 23:19:32 +0200
Message-ID: <20190324211932.GK9224@smile.fi.intel.com>
References: <20190322132108.25501-1-sakari.ailus@linux.intel.com>
 <CAMuHMdVmqqjVx7As9AAywYxYXG=grijF5rF77OBn6TUjM9+xKw@mail.gmail.com>
 <20190322135350.2btpno7vspvewxvk@paasikivi.fi.intel.com>
 <20190322170550.GX9224@smile.fi.intel.com>
 <20190324211008.lypghym3gqcp62th@mara.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190324211008.lypghym3gqcp62th@mara.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Petr Mladek <pmladek@suse.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, scsi <linux-scsi@vger.kernel.org>, Linux PM list <linux-pm@vger.kernel.org>, Linux MMC List <linux-mmc@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, linux-um@lists.infradead.org, linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org, ACPI Devel Maling List <linux-acpi@vger.kernel.org>, netdev <netdev@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>, linux-pci <linux-pci@vger.kernel.org>, sparclinux <sparclinux@vger.kernel.org>, xen-devel@lists.xenproject.org, ceph-devel <ceph-devel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Linux ARM <linux-arm-kernel@l>
List-Id: linux-scsi@vger.kernel.org

On Sun, Mar 24, 2019 at 11:10:08PM +0200, Sakari Ailus wrote:
> On Fri, Mar 22, 2019 at 07:05:50PM +0200, Andy Shevchenko wrote:
> > On Fri, Mar 22, 2019 at 03:53:50PM +0200, Sakari Ailus wrote:
> > 
> > > Porting a patch
> > > forward should have no issues either as checkpatch.pl has been complaining
> > > of the use of %pf and %pF for a while now.
> > 
> > And that's exactly the reason why I think instead of removing warning on
> > checkpatch, it makes sense to convert to an error for a while. People are
> > tending read documentation on internet and thus might have outdated one. And
> > yes, the compiler doesn't tell a thing about it.
> > 
> > P.S. Though, if majority of people will tell that I'm wrong, then it's okay to
> > remove.
> 
> I wonder if you wrote this before seeing my other patchset.

Yes, I wrote it before seeing another series.

> What I think could be done is to warn of plain %pf (without following "w")
> in checkpatch.pl, and %pf that is not followed by "w" in the kernel.
> Although we didn't have such checks to begin with. The case is still a
> little bit different as %pf used to be a valid conversion specifier whereas
> %pO likely has never existed.
> 
> So, how about adding such checks in the other set? I can retain %p[fF] check
> here, too, if you like.

Consistency tells me that the warning->error transformation in checkpatch.pl
belongs this series.


-- 
With Best Regards,
Andy Shevchenko
