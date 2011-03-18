From: Greg KH <gregkh@suse.de>
Subject: Re: [PATCH] firmware/efi: export a routine to retrieve efi-variables
 by GUID
Date: Fri, 18 Mar 2011 15:50:16 -0700
Message-ID: <20110318225016.GB15921@suse.de>
References: <20110318221606.26841.92271.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50485 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932177Ab1CRWvZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Mar 2011 18:51:25 -0400
Content-Disposition: inline
In-Reply-To: <20110318221606.26841.92271.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>, linux-scsi@vger.kernel.org, jacek.danecki@intel.com, ed.ciechanowski@intel.com, linux-kernel@vger.kernel.org, dmilburn@redhat.com, edmund.nadolski@intel.com

On Fri, Mar 18, 2011 at 03:16:22PM -0700, Dan Williams wrote:
> From: Dave Jiang <dave.jiang@intel.com>
> 
> The efivars module already scans all available variables, normalizes the
> variable names, and stores them in a list.  Rather than duplicate this
> to efi runtime services interface let drivers query variable data by
> GUID.
> 
> This is needed by the isci driver which relies on an efi variable to
> store critical platform parameters like gloablly unique sas addresses
> and phy configuration parameters.  This is similar to the
> pci_map_biosrom() enabling that allows the isci driver to retrieve the
> same data in the non-efi case.
> 
> For the built-in case efivars is moved to subsys_initcall.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
> Not sure who looks after efivars.c, but get_maintainer.pl and git shortlog
> fingered Greg as a likely target.

Yes, that is me.

> We are currently targeting a late merge of the isci driver through the
> staging tree into 2.6.39.  This is a pre-requisite to be able to use the
> driver on an efi enabled platform.

You are?  That's news to me, why didn't you ask the staging tree
maintainer about this?

I needed all patches in linux-next _before_ the merge window opened to
be able to accept it.  So, sorry, it will have to wait until .40.
Please send me the isci driver and I will be glad to queue it up for
staging for that kernel.

thanks,

greg k-h
