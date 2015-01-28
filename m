From: Greg KH <greg@kroah.com>
Subject: Re: Backport of a fix for HPSA (Disabling a disabled device problem
 during kdump) driver
Date: Tue, 27 Jan 2015 16:18:37 -0800
Message-ID: <20150128001837.GE17677@kroah.com>
References: <CANcb+4va2cYPtfTwd-Mv2X=cG5vTy=pz_wE3S+-d1-5Z9qSFoA@mail.gmail.com>
 <54AC0A17.8020405@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <54AC0A17.8020405@redhat.com>
Sender: stable-owner@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: Masoud Sharbiani <msharbiani@twopensource.com>, stable@vger.kernel.org, Don Brace <Don.Brace@pmcs.com>, JBottomley@parallels.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Jan 06, 2015 at 05:15:19PM +0100, Tomas Henzl wrote:
> On 01/05/2015 07:41 PM, Masoud Sharbiani wrote:
> > Dear stable maintainers,
> > Can you please backport commitid 132aa220b45d60e9b20def1e9d8be9422eed9616
> >  (hpsa: refine the pci enable/disable handling) to 3.10 stable (and
> > earlier, if applicable)?
> 
> Please do not apply this patch isolated from his friend, the
> 859c75aba20264d87dd026bab0d0ca3bff385955 hpsa: add missing pci_set_master in kdump path
> needs to be applied together with the 132aa220b45d60e9b20def1e9d8be9422eed9616 .
> 
> In addition to that, after the original issue goes away you may notice sometimes
> an unhandled irq 16 message, to fix this a patch is posted 
> here http://www.spinics.net/lists/linux-scsi/msg80316.html
> This patch still awaits a maintainers review though.
> 
> Probably the best idea is to wait until the issue is solved completely.

I'll wait, when it all gets worked out, please let stable@ know what
patches to apply where.

thanks,

greg k-h
