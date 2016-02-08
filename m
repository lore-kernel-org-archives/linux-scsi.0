From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 3/3] add support for DWC UFS Host Controller
Date: Mon, 8 Feb 2016 16:15:30 +0000
Message-ID: <20160208161530.GB14146@leverpostej>
References: <cover.1454498292.git.jpinto@synopsys.com>
 <2072510.CA47OHQsUN@wuerfel>
 <56B2164E.5060007@synopsys.com>
 <2087303.0ORDEBS3hn@wuerfel>
 <56B222C8.5010509@synopsys.com>
 <20160204162700.GD17587@leverpostej>
 <56B8B177.2050000@synopsys.com>
 <20160208153005.GB12536@leverpostej>
 <56B8B614.10306@synopsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56B8B614.10306@synopsys.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Joao Pinto <Joao.Pinto@synopsys.com>
Cc: Arnd Bergmann <arnd@arndb.de>, santosh.sy@samsung.com, h.vinayak@samsung.com, julian.calaby@gmail.com, akinobu.mita@gmail.com, hch@infradead.org, gbroner@codeaurora.org, subhashj@codeaurora.org, CARLOS.PALMINHA@synopsys.com, ijc+devicetree@hellion.org.uk, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, devicetree@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Feb 08, 2016 at 03:36:52PM +0000, Joao Pinto wrote:
> Hi Mark,
> 
> On 2/8/2016 3:30 PM, Mark Rutland wrote:
> > On Mon, Feb 08, 2016 at 03:17:11PM +0000, Joao Pinto wrote:
> >> Hi Mark and Arnd,
> >> Are you saying that a user that puts "snps,ufshcd-1.1"
> >> in the DT compatibility string disables the UFS 2.0 in the core driver despite
> >> the controller is 2.0? Please clarify.
> > 
> > If you can consistently and safely detect that the HW is 2.0, using 2.0
> > functionality is fine.
> > 
> > Regardless, you should have a -1.1 compatible string for the 1.1 HW, and
> > a -2.0 string for the 2.0 HW, so that DTs are explicit about what the
> > hardware is. If 2.0 is intended to be a superset of 1.1, you can have a
> > 1.1 fallback entry for the 2.0 hardware.
> > 
> 
> Ok, I will include the version in the compatibility strings, but if someone
> mentions "snps,ufshcd-1.1" only and the driver detects that the HW is 2.0
> capable it will activate the 2.0 features independently of what mentioned in the
> DT, correct?

As above, if that can be detected safely and reliably, then I don't see
a problem with that.

Thanks,
Mark.
