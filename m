From: David VomLehn <dvomlehn@cisco.com>
Subject: Re: [PATCH 1/7] initdev:kernel:Asynchronously-discovered device
	synchronization, v6
Date: Mon, 8 Jun 2009 15:11:02 -0700
Message-ID: <20090608221102.GA22222@cuplxvomd02.corp.sa.net>
References: <20090606023403.GA5645@cuplxvomd02.corp.sa.net> <4A2A2C26.1070106@s5r6.in-berlin.de> <4A2A320F.5020008@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4A2A320F.5020008@s5r6.in-berlin.de>
Sender: netdev-owner@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, linux-usb@vger.kernel.org, greg@kroah.com, linux-scsi@vger.kernel.org, netdev@vger.kernel.org, arjan@infradead.org
List-Id: linux-scsi@vger.kernel.org

On Sat, Jun 06, 2009 at 05:08:31AM -0400, Stefan Richter wrote:
> I wrote:
> > What happens if the calls or the call arguments aren't balanced, e.g. 
> > due to a mistake in an error path?  The kernel will hang?
> 
> Yes, unless the waiting subsystems implement timeouts.

This is absolutely correct. It would, of course, be possible to add a
timeout, but it would really be papering over a bug. If this every happened,
the proper thing would be to fix the problem.

> Stefan Richter
