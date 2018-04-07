From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 01/10] staging: fnic2 add initialization
Date: Sat, 7 Apr 2018 08:09:01 +0200
Message-ID: <20180407060901.GA18744@kroah.com>
References: <20180405211519.GA12584@osmithde-lnx.cisco.com>
 <20180405211644.GB12584@osmithde-lnx.cisco.com>
 <20180406050752.GC27591@kroah.com>
 <20180406220010.GA23478@osmithde-lnx.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180406220010.GA23478@osmithde-lnx.cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oliver Smith-Denny <osmithde@cisco.com>
Cc: Sesidhar Baddela <sebaddel@cisco.com>, Gian Carlo Boffa <gcboffa@cisco.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Apr 06, 2018 at 03:00:11PM -0700, Oliver Smith-Denny wrote:
> On Fri, Apr 06, 2018 at 07:07:52AM +0200, Greg Kroah-Hartman wrote:
> > Why is this a drivers/staging/ driver at all?  What is keeping you from
> > getting this merged into the "proper" place in the kernel?
> > 
> > If you have a staging driver, you have to have a TODO file in the
> > directory listing what is keeping this in the staging section.
> 
> Sorry Greg, we do have a TODO file in the directory, but it was
> part of patch 10/10. I can move that to be part of patch 01/10.

Ah, I missed that, sorry.

> We think that this driver is a drivers/staging driver because
> there are some changes we want to make before submitting
> the driver to the "proper" place. Specifically, we want to
> change how we allocate memory (move from a static allocation
> to a mempool scenario), which will require some other code
> changes.

Why not just take a week and do that?  I can't take any new patches
until 4.17-rc1 is out anyway.

> Also, we want to investigate if we need to change our locking schema.

Again, why not just take the time to do that?

> We think that making this driver part of the drivers/staging community
> will allow interested people to try the driver in its current state
> and offer up ideas as to its continued development.

Have you asked the scsi developers what they think about this?

And why not copy the staging developer mailing list on this patch
series?

> If you think that this driver doesn't belong in the
> drivers/staging community, we are happy to explore getting
> the driver fully ready on our side and getting it into the
> "proper" place.

I'll take anything in staging as long as it has the correct license and
builds, that's not an issue :)  But I do want to get agreement from the
SCSI maintainers that this is ok to have in this part of the kernel as
sometimes it can cause merge issues if there are core api changes.

> > Please read the documentation on how to properly use SPDX tags on kernel
> > files.  This needs to be the first line of the file.
> 
> Thanks Greg, I fixed the SPDX tags and removed all the boilerplate,
> including the LICENSE file. Also, I have updated the MAINTAINERS
> file, which accidentally slipped by my first patch set. If you
> think that drivers/staging is a good temporary home for this
> driver, then I will send another patchset with the changes,
> as well as the changes from your other replies to patch 02/10
> and patch 03/10.

A respin of this would be nice, and again, I can't do anything with it
until 4.17-rc1 is out.

thanks,

greg k-h
