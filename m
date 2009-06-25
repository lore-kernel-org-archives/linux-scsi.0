From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: [dm-devel] REQUEST for new 'topology' metrics to be moved out
 of the 'queue' sysfs directory.
Date: Thu, 25 Jun 2009 12:36:15 +0100
Message-ID: <4A43612F.2000100@anonymous.org.uk>
References: <19010.62951.886231.96622@notabene.brown>    <yq11vp8spxo.fsf@sermon.lab.mkp.net> <125b48b7ffc99a496fbdd512f38cada5.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <125b48b7ffc99a496fbdd512f38cada5.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Alasdair G Kergon <agk@redhat.com>, jens.axboe@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org, linux-fsdevel@vger.kernel.org, device-mapper development <dm-devel@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On 25/06/2009 12:07, NeilBrown wrote:
[...]
> stripe-width is only really needed on raid4/5/6 as it is aimed at
> avoiding read-modify-write, so it would be the stripe size, which would
> be minimum_io_size.
[...]
> stride-size is used for raid0 or raid4, or the "Asymmetric" raid5 layouts.
> It allows ext3 to stagger which drive certain 'hot' data structures are
> on.  The current metrics don't allow for that at all.
> I'm not saying they should, and I'm not sure how they could.  But it
> is sad.

Even sadder, when a raid 0/4/5/6 is reshaped over more discs (and 
probably other scenarios outwith md), both stripe-width and stride-size 
change. Is there any prospect this new stacking could give us the 
opportunity to tell our client (LVM, filesystem, whatever) about the 
change, or that they'll be able to take advantage of it?

Cheers,

John.
