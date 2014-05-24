From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] acornscsi: remove linked command support
Date: Sat, 24 May 2014 16:13:37 +0400
Message-ID: <1400933617.6956.34.camel@dabdike.int.hansenpartnership.com>
References: <1400926433.31526.89.camel@x220> <538075E0.4080001@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <538075E0.4080001@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Paul Bolle <pebolle@tiscali.nl>, Russell King <linux@arm.linux.org.uk>, linux-arm-kernel@lists.infradead.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, 2014-05-24 at 12:35 +0200, Hannes Reinecke wrote:
[...]
> I'm all for it. Removing never-really-implemented feature on obsolete 
> hardware is always a good idea.
> 
> Acked-by: Hannes Reinecke <hare@suse.de>

Wait, no, that's not a good idea.  We leave obsolete drivers to bitrot.
Particularly we try not to touch them unless we have to because there
might be a few people still using them and the more we tamper, the
greater the risk that something gets broken.  On that principle, since
there's no real reason to remove the code, it should stay ... until the
whole driver bitrots to the extent that we can no-longer compile it.

However, I'll do this if the Maintainer (rmk) acks ... because if it
breaks he gets to fix it.

James
