From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v9 07/10] block: add a new interface to block events
Date: Mon, 12 Nov 2012 11:21:02 -0800
Message-ID: <20121112192102.GG5560@mtj.dyndns.org>
References: <20121112191440.GF5560@mtj.dyndns.org>
 <Pine.LNX.4.44L0.1211121417230.31816-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1211121417230.31816-100000@netrider.rowland.org>
Sender: linux-pm-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Aaron Lu <aaron.lu@intel.com>, Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Jeff Wu <jeff.wu@amd.com>, Aaron Lu <aaron.lwe@gmail.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello, Alan.

On Mon, Nov 12, 2012 at 02:18:11PM -0500, Alan Stern wrote:
> > Weren't you gonna do something different about this?  I mean, if sr
> > knows that autopm kicked in, it can simply tell the block layer that
> > nothing is going on.  Wouldn't that be simpler?
> 
> It wouldn't work for non-ZP drives.  They do need to be polled, even 
> when suspended.

Hmmm... a bit confused, what would autopm do for those non-ZP devices?
Would it make any difference?

Thanks.

-- 
tejun
