From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] get rid of ->detect for upper layer drivers
Date: Thu, 7 Nov 2002 16:36:15 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021107163615.A9189@lst.de>
References: <200211071225.EAA29497@adam.yggdrasil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200211071225.EAA29497@adam.yggdrasil.com>; from adam@yggdrasil.com on Thu, Nov 07, 2002 at 04:25:24AM -0800
List-Id: linux-scsi@vger.kernel.org
To: "Adam J. Richter" <adam@yggdrasil.com>
Cc: linux-scsi@vger.kernel.org

On Thu, Nov 07, 2002 at 04:25:24AM -0800, Adam J. Richter wrote:
> 	I think we can get cleaner code by *not* doing that.
> 
> 	If we keep Scsi_Device_Template.detect and just change it so
> that it has no side effects like incrementing a counter, then we can
> shrink scsi_bus_match, previously a list of special cases, like so
> (just typed this code in, haven't tried to compile it):

I'd prefer to get rid of scsi_bus_match entirely.  But if we have to
keep it having a side-effect free method ito the drivers is probably
the right thing, yes.  I'd rather call it "math", though to a) show
what it's used for and b) not fool people porting drivers from 2.4 to
2.5.

