From: Greg KH <greg@kroah.com>
Subject: Re: FW: MSI-X on 2.6.15
Date: Mon, 30 Jan 2006 09:38:52 -0800
Message-ID: <20060130173852.GA16259@kroah.com>
References: <D4CFB69C345C394284E4B78B876C1CF10B8AC113@cceexc23.americas.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S964844AbWA3RjU@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <D4CFB69C345C394284E4B78B876C1CF10B8AC113@cceexc23.americas.cpqcorp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Cc: Mark Maule <maule@sgi.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, "Patterson, Andrew D (Linux R&D)" <andrew.patterson@hp.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Jan 30, 2006 at 10:33:50AM -0600, Miller, Mike (OS Dev) wrote:
> Greg KH,
> We have the same results on 2.6.15, the MSI-X table is all zeroes. See
> below. Any ideas of what to do do next? The driver works on x86_64. Is
> there any thing extra I need to do on ia64?

ia64 didn't really have msi support before the latest -mm kernel, right
Mark?

> Andrew, can you try 2.6.16-rc1 and/or the rc1-git4 kernels?

How about the -mm kernel?

thanks,

greg k-h
