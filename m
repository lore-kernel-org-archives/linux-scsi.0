From: Rob Herring <robh@kernel.org>
Subject: Re: [PATCH V3 1/3] scsi: ufs: set the device reference clock setting
Date: Wed, 20 Jun 2018 12:01:54 -0600
Message-ID: <20180620180154.GA18559@rob-hp-laptop>
References: <1528981432-23065-1-git-send-email-sayalil@codeaurora.org>
 <1528981432-23065-2-git-send-email-sayalil@codeaurora.org>
 <bf87ec58-69c0-fe59-cfa1-8dc7dc80ca46@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <bf87ec58-69c0-fe59-cfa1-8dc7dc80ca46@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Sayali Lokhande <sayalil@codeaurora.org>, subhashj@codeaurora.org, cang@codeaurora.org, vivek.gautam@codeaurora.org, rnayak@codeaurora.org, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, asutoshd@codeaurora.org, evgreen@chromium.org, riteshh@codeaurora.org, linux-scsi@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>, Mathieu Malaterre <malat@debian.org>, "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" <devicetree@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Jun 20, 2018 at 10:26:07AM +0300, Adrian Hunter wrote:
> On 14/06/18 16:03, Sayali Lokhande wrote:
> > From: Subhash Jadavani <subhashj@codeaurora.org>
> > 
> > UFS host supplies the reference clock to UFS device and UFS device
> > specification allows host to provide one of the 4 frequencies (19.2 MHz,
> > 26 MHz, 38.4 MHz, 52 MHz) for reference clock. Host should set the
> > device reference clock frequency setting in the device based on what
> > frequency it is supplying to UFS device.
> > 
> > Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
> > Signed-off-by: Can Guo <cang@codeaurora.org>
> > Signed-off-by: Sayali Lokhande <sayalil@codeaurora.org>
> 
> I have repeated my V2 comments below.  Please address these when you post
> V4.  Also please provide a change log for each patch version.

Do I have to repeat my V2 comments too? Please don't send a V4 until the 
discussion on V2 is resolved.

Rob
