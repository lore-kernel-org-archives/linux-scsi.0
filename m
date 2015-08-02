From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 0/6] ZAC host-aware device support
Date: Sun, 2 Aug 2015 11:47:52 -0400
Message-ID: <20150802154752.GB31100@mtj.duckdns.org>
References: <1438347728-106434-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1438347728-106434-1-git-send-email-hare@suse.de>
Sender: linux-ide-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, James Bottomley <james.bottomley@hansenpartnership.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Jul 31, 2015 at 03:02:02PM +0200, Hannes Reinecke wrote:
> Hi all,
> 
> here is a patchset for adding ZAC host-aware device support to libata.
> Main bits are translations for ZBC IN and ZBC OUT; others are the
> required plumbing like generating the correct VPD pages.
> James, do you require a separate patch for adding ZBC IN and ZBC OUT
> or is it okay to have it queued here?
> 
> As usual, reviews and comments are welcome.

Can you please give an overview of why we would want this?

Thanks.

-- 
tejun
