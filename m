From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: aic7xxx 6.2.24 bug report
Date: Sat, 28 Dec 2002 13:48:53 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <766648112.1041108533@aslan.scsiguy.com>
References: <20021228204505.GC9319@linnie.riede.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20021228204505.GC9319@linnie.riede.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: wrlk@riede.org, linux-scsi@vger.kernel.org

> Here's a problem with aic7xxx 6.2.24 in 2.5.53 -- it refuses to handle 
> my /dev/sdb. Works just fine with 6.2.4 in 2.5.52. 
> 
> This is from my log when booting linux 2.5.53:

Can you retest enabling the debug features of the driver and setting
the debug mask to 0x63?  Something like, assuming you are using a
module:

options aic7xxx aic7xxx=verbose.debug:0x63

--
Justin

