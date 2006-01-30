From: Ashok Raj <ashok.raj@intel.com>
Subject: Re: FW: MSI-X on 2.6.15
Date: Mon, 30 Jan 2006 09:56:30 -0800
Message-ID: <20060130095630.A7765@unix-os.sc.intel.com>
References: <20060130173852.GA16259@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fmr21.intel.com ([143.183.121.13]:22935 "EHLO
	scsfmr001.sc.intel.com") by vger.kernel.org with ESMTP
	id S932327AbWA3R4c (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Jan 2006 12:56:32 -0500
Content-Disposition: inline
In-Reply-To: <20060130173852.GA16259@kroah.com>; from greg@kroah.com on Mon, Jan 30, 2006 at 09:38:52AM -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>, Mark Maule <maule@sgi.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, "Patterson, Andrew D (Linux R&D)" <andrew.patterson@hp.com>

On Mon, Jan 30, 2006 at 09:38:52AM -0800, Greg KH wrote:
> 
>    On Mon, Jan 30, 2006 at 10:33:50AM -0600, Miller, Mike (OS Dev) wrote:
>    > Greg KH,
>    >  We  have the same results on 2.6.15, the MSI-X table is all zeroes.
>    See
>    >  below. Any ideas of what to do do next? The driver works on x86_64.
>    Is
>    > there any thing extra I need to do on ia64?
> 
>    ia64  didn't  really  have  msi  support before the latest -mm kernel,
>    right
>    Mark?

It wasnt enabled in any default configs, but i believe its functional
even earlier. Atleast when i changed the method for irq migration via 
/proc, i remember testing on ia64 on ixgb driver. 

I havent followed the register_ops() discussion but believe it just changed
the default vector allocation to arch/platform types. But the core
msi should have worked even earlier.

Cheers,
ashok
