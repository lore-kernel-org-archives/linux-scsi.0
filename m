From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: 2.5.63-mm2
Date: Wed, 5 Mar 2003 14:01:40 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030305220140.GA4014@beaverton.ibm.com>
References: <20030302180959.3c9c437a.akpm@digeo.com> <1046815078.12931.79.camel@ibm-b> <20030304234042.2553deed.akpm@digeo.com> <20030305173854.GA1090@beaverton.ibm.com> <20030305185231.GE1090@beaverton.ibm.com> <20030305133305.A16075@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030305133305.A16075@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Andrew Morton <akpm@digeo.com>, Mark Wong <markw@osdl.org>, linux-scsi@vger.kernel.org

Thanks for trying this Patrick. I have added this to my list of systems
available that display error handling signatures for future testing.

Patrick Mansfield [patmans@us.ibm.com] wrote:
> On Wed, Mar 05, 2003 at 10:52:31AM -0800, Mike Anderson wrote:
> > The patch below fixed the problem on my system. I had my list empty
> > checks reversed if aborting and bus device reset failed. The condition
> > that causes the error handler to run is still unknown. I will look at it
> > when I get a chance.
> 
> Mike -
> 
> With your patch, I am able to boot again using the feral driver with an
> isp1020 (on a NUMAQ system).
> 
> Though I still do not know why the feral gets a time out but qlogicisp
> does not. It is apparently a read that times out while mounting root for
> the first time (readonly), so this is not the first read sent to the drive
> (partition code should have sent a read). It could be the queue_depth
> settings (qlogicisp sets to 1, I have feral setting them to 16).
> 
-andmike
--
Michael Anderson
andmike@us.ibm.com

