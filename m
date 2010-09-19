From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 0/17]: New SCSI target framework (SCST) with dev handlers
 and 2 target drivers
Date: Sun, 19 Sep 2010 11:54:37 +0200
Message-ID: <AANLkTi=d1ZYrOxP3iMt4+qE628FhzassD9=8Q1V+unNE@mail.gmail.com>
References: <4C8F886E.2080407@vlnb.net>
	<20100915055649.GB22219@core.coreip.homeip.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100915055649.GB22219@core.coreip.homeip.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>, James Bottomley <James.Bottomley@hansenpartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Jeff Garzik <jeff@garzik.org>, Vu Pham <vuhuong@mellanox.com>, James Smart <James.Smart@emulex.com>, Joe Eykholt <jeykholt@cisco.com>, Andy Yan <ayan@marvell.com>, Chetan Loke <generationgnu@yahoo.com>, Hannes Reinecke <hare@suse.de>, Richard Sharpe <realrichardsharpe@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Sep 15, 2010 at 7:56 AM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
>
> Hi Vladislav,
>
> On Tue, Sep 14, 2010 at 06:36:30PM +0400, Vladislav Bolkhovitin wrote:
> > Hi All,
> >
> > Please review this second iteration of the patch set of the new
> > (although, perhaps, the oldest) SCSI target framework for Linux SCST
> > with a set of dev handlers and 2 target drivers: for local access
> > (scst_local) and for Infiniband SRP (srpt).
> >
>
> [ ... ]
>
> And too many "naked returns", I believe common style is to only have
> return for non-void functions.

Hello Dmitry,

If there is agreement among kernel maintainers that return statements
at the end of functions that do not return a value should be avoided,
it might be a good idea to let checkpatch complain about such return
statements. Currently checkpatch doesn't complain about such return
statements.

Bart.
