From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH RESEND 0/1] AHCI: Optimize interrupt processing
Date: Fri, 19 Jul 2013 14:05:34 -0700
Message-ID: <1374267934.7397.1062.camel@haakon3.risingtidesystems.com>
References: <cover.1369155164.git.agordeev@redhat.com>
	 <20130521235003.GE6985@mtj.dyndns.org>
	 <20130522143923.GD19383@dhcp-26-207.brq.redhat.com>
	 <20130522170305.GD9563@kernel.dk>
	 <20130711102630.GA11133@dhcp-26-207.brq.redhat.com>
	 <1373583637.7397.370.camel@haakon3.risingtidesystems.com>
	 <20130712074559.GA8727@dhcp-26-207.brq.redhat.com>
	 <1373692812.7397.625.camel@haakon3.risingtidesystems.com>
	 <20130716183207.GA6402@dhcp-26-207.brq.redhat.com>
	 <1374010683.7397.880.camel@haakon3.risingtidesystems.com>
	 <20130717161909.GB21468@dhcp-26-207.brq.redhat.com>
	 <1374173515.7397.948.camel@haakon3.risingtidesystems.com>
	 <51E83E32.9050306@cs.wisc.edu>
	 <1374193399.7397.973.camel@haakon3.risingtidesystems.com>
	 <51E96239.8080409@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <51E96239.8080409@cs.wisc.edu>
Sender: linux-ide-owner@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Alexander Gordeev <agordeev@redhat.com>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>, Jens Axboe <axboe@kernel.dk>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2013-07-19 at 09:58 -0600, Mike Christie wrote:
> On 07/18/2013 06:23 PM, Nicholas A. Bellinger wrote:
> >> Just saw this while trying out iscsi with the scsi-mq stuff :)
> >> > 
> > Took at stab at this a while back, but ended getting distracted on other
> > items.  Do you have an initial conversion running yet..?
> 
> Not running well :) Have a patch but I am debugging it now. I messed up
> something with the cmd_size stuff.

<nod>, looking forward to see ib_iser move beyond the existing
scsi_request_fn() bottleneck.   ;)

Feel free to send me the WIP off-list if you'd like another pair of
eyes.

--nab



