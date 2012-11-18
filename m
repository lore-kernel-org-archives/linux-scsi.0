From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v9 07/10] block: add a new interface to block events
Date: Sun, 18 Nov 2012 07:05:55 -0800
Message-ID: <20121118150555.GL7306@mtj.dyndns.org>
References: <20121112192102.GG5560@mtj.dyndns.org>
 <Pine.LNX.4.44L0.1211121432050.31816-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1211121432050.31816-100000@netrider.rowland.org>
Sender: linux-pm-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Aaron Lu <aaron.lu@intel.com>, Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Jeff Wu <jeff.wu@amd.com>, Aaron Lu <aaron.lwe@gmail.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello, Alan.

On Mon, Nov 12, 2012 at 02:34:01PM -0500, Alan Stern wrote:
> It wouldn't do anything for the device, but it would allow the device's
> parent to go to low power in between polls.  That's why Aaron at one
> point suggested lengthening the polling interval.

Ah, okay.  Entering and leaving suspend even every two seconds may
save noticeable power for some controllers.  Does that, tho, mean that
the port would get reset every two seconds?  If so (I can't see how
else it would behave), it may not really work.  I mean, you would be
spending about ten seconds reinitiaizing everything and then enter
sleep and do it all over again two seconds later, most likely wasting
power in the process.  Sounds weird to me.  What am I missing?

Thanks.

-- 
tejun
