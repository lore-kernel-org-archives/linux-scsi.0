From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: HEADS UP for QLA2100 users
Date: Fri, 28 Oct 2005 16:03:03 -0700
Message-ID: <20051028230303.GI15018@plap.qlogic.org>
References: <20051024014838.0dd491bb.akpm@osdl.org> <1130186927.6831.23.camel@localhost.localdomain> <20051024141646.6265c0da.akpm@osdl.org> <20051027152637.GC7889@plap.qlogic.org> <20051027190227.GA16211@infradead.org> <20051027215313.GB7889@plap.qlogic.org> <20051028225155.GA13958@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1750734AbVJ1XDF@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20051028225155.GA13958@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 28 Oct 2005, Christoph Hellwig wrote:

> On Thu, Oct 27, 2005 at 02:53:13PM -0700, Andrew Vasquez wrote:
> 
> > I'm still in the process of ironing out the .bin distribution details
> > locally, but perhaps once we migrate to firmware-loading exclusively
> > via request_firmware(), the (small?) contigent of 2100 could use the
> > EF variant I referenced above.
> 
> You know, I'm in favour of getting firmware images in the kernel image,
> but what's the problem of simply downgrading the 2100 firmware until
> we get rid of the builtin firmware for all qla2xxx variants?

I have no problems with submitting 1.17.38 EF for inclusion upstream.
My only hope is that for the (other) 2100 user out there that use the
latest 2100 firmware and are not experiencing problems, the downgrade
does not break anything.

That's another reason I posed the following question:

> > Could I get another informal count of 2100 users who are still having
> > problems with qla2xxx?

Perhaps I should also ask:

	Who's running 2100 cards with the latest qla2xxx driver and
	are experiencing no problems?

--
AV
