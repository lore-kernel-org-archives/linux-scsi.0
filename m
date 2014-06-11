From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [ANNOUNCE] scsi patch queue tree
Date: Wed, 11 Jun 2014 07:17:34 -0700
Message-ID: <1402496254.2523.3.camel@dabdike.int.hansenpartnership.com>
References: <20140519140614.GA12183@infradead.org>
	 <20140611120143.GA26071@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140611120143.GA26071@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2014-06-11 at 05:01 -0700, Christoph Hellwig wrote:
> After this first pull for the 3.16 merge window it seems like this
> worked out fairly well - we got a large number of patches in, and all
> reviewed by a second pair of eyes.
> 
> How should we go on from this?  The drivers-for-3.16-2 branch, which had
> the late lpfs and hpsa updates didn't make it into the pull request for
> Linus, do you intend to skip them for this window?  If not do you still
> want to have another branch for the other pending smaller updates?

No, I was waiting to check if there was any reason to have them split,
but I think we've scope today or tomorrow.

The only other outstanding thing is the fsync bug fix, which is waiting
Jens' investigation of the block issues it may cause, but I'm inclined
to send it anyway and fix up block later if there's a problem.

James
