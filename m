From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: Fw: 2.6.6-rc3 ia64 smp_call_function() called with interrupts disabled
Date: Thu, 13 May 2004 07:43:26 -0700
Sender: linux-ia64-owner@vger.kernel.org
Message-ID: <20040513074326.A30691@beaverton.ibm.com>
References: <20040502214525.5ad05bed.akpm@osdl.org> <20040503122948.GI2281@parcelfarce.linux.theplanet.co.uk> <20040503203512.GP2281@parcelfarce.linux.theplanet.co.uk> <40A36286.4020604@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ia64-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <40A36286.4020604@torque.net>; from dougg@torque.net on Thu, May 13, 2004 at 09:56:54PM +1000
To: Douglas Gilbert <dougg@torque.net>
Cc: Matthew Wilcox <willy@debian.org>, Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org, linux-ia64@vger.kernel.org, James.Bottomley@steeleye.com
List-Id: linux-scsi@vger.kernel.org

On Thu, May 13, 2004 at 09:56:54PM +1000, Douglas Gilbert wrote:

> Sorry, I missed this thread. The change looks good and survived
> about one hour of scsi_debug bashing (on i386). I also checked
> it against the previous version.

I hit the badness yesterday, the badness became a hang when I had hotplug,
udev and scsi_id running. With the patch no badness and no hang.

-- Patrick Mansfield
