From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 0/4] FCoE Sysfs
Date: Mon, 12 Mar 2012 21:56:27 -0700
Message-ID: <20120313045627.GA15426@kroah.com>
References: <20120312230915.10580.52548.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48788 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757174Ab2CME4c (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Mar 2012 00:56:32 -0400
Received: by iagz16 with SMTP id z16so258882iag.19
        for <linux-scsi@vger.kernel.org>; Mon, 12 Mar 2012 21:56:31 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20120312230915.10580.52548.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert Love <robert.w.love@intel.com>
Cc: linux-scsi@vger.kernel.org, james.smart@emulex.com, giridhar.malavali@qlogic.com

On Mon, Mar 12, 2012 at 04:09:15PM -0700, Robert Love wrote:
> This patch series adds a sysfs layer to libfcoe. It adds
> a sysfs instance for FIP controllers (a SW entity) and
> discovered Fibre Channel Forwarders (FCFs), which are
> simply FCoE switches.
> 
> The new sysfs code is used by any driver that currently
> uses libfcoe, namely fcoe.ko and bnx2fc_fcoe.ko. Any other
> FCoE capable device that wishes to use the high-level APIs
> defined in fcoe_syfs.h may, without having to use the
> the protocol processing portions of libfcoe.
> 
> The code borrows heavily from the FC Transport, but is
> less complicated because it does not need to interact
> with the SCSI layer directly.
> 
> I think one thing to consider with this series is that
> drivers, such as traditional HBAs, which wish to use
> this infrastructure will now need to depend on libfcoe.ko.
> It was either this or create a superfluous kernel module;
> I think libfcoe is an appropriate place for this code.
> 
> This series was created against scsi-misc + 9 patches
> mailed by me to linux-scsi on 03/09/12. (Note that 10
> patches were mailed, but that patch 01/10 will be dropped)
> 
> I'm not sure if there's somewhere I should cross-post
> this for general sysfs review. I don't think I'm doing
> anything odd; I added Greg K-H to the CC list to try and
> get some sysfs eyes on this code.

As you are adding new sysfs files, please always add the proper
Documentation/ABI/ files as well.

thanks,

greg k-h
