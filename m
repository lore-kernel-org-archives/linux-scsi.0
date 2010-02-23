From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: qla2xxx UNDERRUNS and failed multipath paths
Date: Tue, 23 Feb 2010 14:58:22 -0800
Message-ID: <20100223225822.GA2378@plapa.local>
References: <20100223223938.GA4612@allantgroup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100223223938.GA4612@allantgroup.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy <genanr@emsphone.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 23 Feb 2010, Andy wrote:

> I discovered I was easily able to trigger path failures in kernel 2.6.32.8.
> Since I had known I had not had this problem in the 2.6.27 series kernels, I
> bisected between 2.6.27 and 2.6.28 and found that the following commit
> causes UNDERRUNS to turn into a serious problem.
> 
> 2d136938792ba04bf3b6bb2d3a2807dc05c396fc - Additional residual-count
> corrections during UNDERRUN handling
> 
> HBA: QLA2460 (ISP2432)
> FW: 4.04.05 (486)
> 
> I have since tested 2.6.32.8 with and without the patch.
> 
> I do have a few systems running kernels that have the patch that run fine,
> but most they seem to be using newer HBAs (most qla2560/2562, but one is running
> a qla2462 fw:4.04.05 (486)).
> 

Addressed here:

[SCSI] qla2xxx: Properly handle UNDERRUN completion statuses.
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=0f00a206ccb1dc644b6770ef25f185610fee6962

Regards,
Andrew Vasquez
