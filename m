From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v5 5/8] char: rpmb: add RPMB simulation device
Date: Thu, 1 Sep 2016 22:45:47 +0200
Message-ID: <20160901204547.GA5960@kroah.com>
References: <1468873673-21776-1-git-send-email-tomas.winkler@intel.com>
 <1468873673-21776-6-git-send-email-tomas.winkler@intel.com>
 <20160831105845.GE10180@kroah.com>
 <5B8DA87D05A7694D9FA63FD143655C1B542C5B98@hasmsx108.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B542C5B98@hasmsx108.ger.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: Ulf Hansson <ulf.hansson@linaro.org>, "Hunter, Adrian" <adrian.hunter@intel.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Vinayak Holikatti <vinholikatti@gmail.com>, Andy Lutomirski <luto@kernel.org>, Arve Hj?nnev?g <arve@android.com>, Michael Ryleev <gmar@google.com>, Joao Pinto <Joao.Pinto@synopsys.com>, Christoph Hellwig <hch@lst.de>, Yaniv Gardi <ygardi@codeaurora.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Sep 01, 2016 at 08:25:28PM +0000, Winkler, Tomas wrote:
> > On Mon, Jul 18, 2016 at 11:27:50PM +0300, Tomas Winkler wrote:
> > > This is a simple platform device used for testing the RPMB subsystem.
> > > +static struct platform_device *rpmb_sim_pdev;
> > 
> > A platform device?  Ick, no please don't abuse that interface for this type of
> > thing.  Make it a real device if you have one, and put it in the proper place.  If
> > it's a "virtual" device, great, use that.  But don't make something up like this
> > please.
> 
> This is a virtual device (simulation), nothing behind it just a chunk of memory.
> Is this there any information missing to make it clearer? 

Don't make it a platform device, make it a "virtual" device, don't abuse
the platform device/driver interface for something that isn't really a
platform device.

thanks,

greg k-h
