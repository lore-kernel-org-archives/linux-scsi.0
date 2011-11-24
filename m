From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v3 3/6] [SCSI] runtime resume device before system
 suspend
Date: Thu, 24 Nov 2011 11:57:03 -0800
Message-ID: <20111124195703.GA6735@google.com>
References: <1322137287.2597.10.camel@hp6530s>
 <Pine.LNX.4.44L0.1111241123030.21532-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1111241123030.21532-100000@netrider.rowland.org>
Sender: linux-ide-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Lin Ming <ming.m.lin@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <JBottomley@parallels.com>, "Huang, Ying" <ying.huang@intel.com>, "Zhang, Rui" <rui.zhang@intel.com>
List-Id: linux-scsi@vger.kernel.org

Hello,

On Thu, Nov 24, 2011 at 11:36:20AM -0500, Alan Stern wrote:
> I think this email discussion has answered his objection: The only SCSI
> top-level driver implementing runtime suspend is sd, and sd treats
> runtime suspend the same as system sleep.  It might be a good idea to
> add a comment with this explanation along with the new code, however.

Hmmm... I see.  This shouldn't affect host controller states - we'll
be skipping only the drive PM transitions, right?  As long as it's
well documented, I guess it's okay but at the same time I don't think
it's such a big deal to spin up drives when the system is entering
hibernation from runtime powersave.  On most systems, they'll need to
be spun up for image dump pretty soon anyway.

Thanks.

-- 
tejun
