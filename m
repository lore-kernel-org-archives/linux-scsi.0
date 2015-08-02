From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/6] libata: Do not retry commands with valid autosense
Date: Sun, 2 Aug 2015 11:44:15 -0400
Message-ID: <20150802154415.GA31100@mtj.duckdns.org>
References: <1438347728-106434-1-git-send-email-hare@suse.de>
 <1438347728-106434-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1438347728-106434-2-git-send-email-hare@suse.de>
Sender: linux-ide-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, James Bottomley <james.bottomley@hansenpartnership.com>
List-Id: linux-scsi@vger.kernel.org

Hello,

On Fri, Jul 31, 2015 at 03:02:03PM +0200, Hannes Reinecke wrote:
> If a failed command has a valid autosense there is no need to
> retry it on the ATA level; at best we're incurring the same
> error again. So rather not retry it here, but leave it to
> the SCSI layer to decide if a retry is in order.

Hmmm... I don't know.  So, we change how we handle errors completely
depending on how the device reports it?  Doesn't seem like a
particularly good idea to me.

Thanks.

-- 
tejun
