From: Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v12 8/9] add TC G210 platform driver
Date: Thu, 7 Apr 2016 12:57:08 -0500
Message-ID: <20160407175708.GB32257@rob-hp-laptop>
References: <cover.1459448160.git.jpinto@synopsys.com>
 <aa4c31ba977bc5c07f5706f12c4d9fbb1bb0ec36.1459448160.git.jpinto@synopsys.com>
 <20160404051546.GE17806@rob-hp-laptop>
 <57024677.2060009@synopsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <57024677.2060009@synopsys.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Joao Pinto <Joao.Pinto@synopsys.com>
Cc: tomas.winkler@intel.com, vinholikatti@gmail.com, julian.calaby@gmail.com, akinobu.mita@gmail.com, hch@infradead.org, gbroner@codeaurora.org, subhashj@codeaurora.org, CARLOS.PALMINHA@synopsys.com, ijc+devicetree@hellion.org.uk, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, devicetree@vger.kernel.org, arnd@arndb.de, mark.rutland@arm.com
List-Id: linux-scsi@vger.kernel.org

On Mon, Apr 04, 2016 at 11:48:23AM +0100, Joao Pinto wrote:
> 
> Hi Rob,
> 
> On 4/4/2016 6:15 AM, Rob Herring wrote:
> > On Thu, Mar 31, 2016 at 07:57:21PM +0100, Joao Pinto wrote:
> >> This patch adds a glue platform driver for the Synopsys G210 Test Chip.
> >>
> >> Signed-off-by: Joao Pinto <jpinto@synopsys.com>
> >> ---
> 
> [snip]
> 
> >> +
> >> +Required properties:
> >> +- compatible	: compatible list must contain the PHY type & version:
> >> +			"snps, g210-tc-6.00-20bit"
> >> +			"snps, g210-tc-6.00-40bit"
> > Remove the space              ^
> > 
> >> +		  complemented with the Controller IP version:
> >> +			"snps, dwc-ufshcd-1.40a"
> > 
> > ditto
> 
> Ok, will do that!
> 
> > 
> > Combining the phy and controller compatible strings is a bit strange. 
> > Generally, they would be separate nodes using the common phy binding.
> > 
> 
> Correct, but in this case is just the compatibility string is just to tell the
> dw ufs host that it has a 40-bit or a 20-bit test chip connected. The Test chip
> is initialized by a unipro command sequence and there is no more ops related to it.

Okay. In that case, I think it should be a separate property unless the 
controller h/w is synthesized for one or the other.

Rob
