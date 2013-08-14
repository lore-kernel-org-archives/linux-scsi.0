From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/1] cciss: set max scatter gather entries to 32 on P600
Date: Wed, 14 Aug 2013 14:27:07 -0700
Message-ID: <1376515627.2028.41.camel@dabdike.int.hansenpartnership.com>
References: <20130814205236.GB23042@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130814205236.GB23042@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: mike.miller@hp.com, mikem@thumper.usa.hp.com
Cc: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>, LKML-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, thenzl@redhat.com, bubrown@redhat.com, scameron@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

On Wed, 2013-08-14 at 15:52 -0500, Mike Miller wrote:
> Patch 1/1
> 
> From: Mike Miller <mike.miller@hp.com>
> 
> At one time we used to set the maximum number of scatter gather elements on 
> all Smart Array controllers to 32. At some point in time the firmware began 
> to write the "appropriate" value for each controller into the config table. 
> The cciss driver would then read that and set h->maxsgentries.
> 
>         h->maxsgentries = readl(&(h->cfgtable->MaxSGElements);
> 
> On the P600 that value is 544. Under some workloads a significant 
> performance reduction may result. This patch forces the P600 to use only 32 
> scatter gather elements. Other controllers are not affected.
> 
> Signed-off-by: Mike Miller <mike.miller@hp.com>
> Signed-off-by: Dwight (Bud) Brown <bubrown@redhat.com>
> Signed-off-by: Tomas Henzl <thenzl@redhat.com>
> Acked-by: Stephen M. Cameron <steve.cameron@hp.com>

I don't quite understand the signoff chain on this patch.  For a one
line patch, are you saying it has three authors?

James
