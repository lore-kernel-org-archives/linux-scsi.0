From: Willem Riede <wrlk@riede.org>
Subject: Re: aic7xxx 6.2.24 bug report
Date: Sat, 28 Dec 2002 17:26:20 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021228222620.GE9319@linnie.riede.org>
References: <20021228204505.GC9319@linnie.riede.org> <766648112.1041108533@aslan.scsiguy.com>
Reply-To: wrlk@riede.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <766648112.1041108533@aslan.scsiguy.com>; from gibbs@scsiguy.com on Sat, Dec 28, 2002 at 15:48:53 -0500
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: linux-scsi@vger.kernel.org

On 2002.12.28 15:48 Justin T. Gibbs wrote:
> Can you retest enabling the debug features of the driver and setting
> the debug mask to 0x63?  Something like, assuming you are using a
> module:
> 
> options aic7xxx aic7xxx=verbose.debug:0x63
> 
What am I doing wrong?

Loading aic7xxx module
Parameter aic7xxx length must be 1-1 characters
aic7xxx: `verbose,debug:0x63' invalid for parameter `aic7xxx'


Thanks, Willem Riede.
