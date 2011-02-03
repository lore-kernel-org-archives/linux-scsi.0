From: Greg KH <greg@kroah.com>
Subject: Re: [stable] [PATCH 04/06] mptfusion: mptctl_release is required
 in mptctl.c
Date: Thu, 3 Feb 2011 09:19:30 -0800
Message-ID: <20110203171930.GA11533@kroah.com>
References: <20110203100250.GE23502@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:32995 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756606Ab1BCRVu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Feb 2011 12:21:50 -0500
Content-Disposition: inline
In-Reply-To: <20110203100250.GE23502@lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Kashyap, Desai" <kashyap.desai@lsi.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, Sathya.Prakash@lsi.com, Eric.Moore@lsi.com, stable@kernel.org

On Thu, Feb 03, 2011 at 03:33:00PM +0530, Kashyap, Desai wrote:
> 
> Added missing release callback for file_operations mptctl_fops.
> Without release callback there will be never freed. It remains on 
> mptctl's eent list even after the file is closed and released.
> 
> Relavent RHEL bugzilla is 660871
> 
> Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
> ---

<snip>

This is NOT the way to get patches into a stable kernel release.  Please
read the file, Documentation/stable_kernel_rules.txt for how to do it
properly.

thanks,

greg k-h
