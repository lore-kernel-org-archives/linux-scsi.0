From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [dm-devel] REQUEST for new 'topology' metrics to be moved out
	of the 'queue' sysfs directory.
Date: Fri, 26 Jun 2009 15:49:54 +0200
Message-ID: <20090626134954.GS23611@kernel.dk>
References: <19010.62951.886231.96622@notabene.brown> <yq11vp8spxo.fsf@sermon.lab.mkp.net> <125b48b7ffc99a496fbdd512f38cada5.squirrel@neil.brown.name> <20090625194015.GB31415@kernel.dk> <19012.49673.454853.975682@notabene.brown> <20090626125037.GO23611@kernel.dk> <7c458f2470811a877dd60203b9bbb7ac.squirrel@neil.brown.name> <771af936681abb7ddc2191eb5b6b68d0.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <771af936681abb7ddc2191eb5b6b68d0.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Alasdair G Kergon <agk@redhat.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org, linux-fsdevel@vger.kernel.org, device-mapper development <dm-devel@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Jun 26 2009, NeilBrown wrote:
> On Fri, June 26, 2009 11:16 pm, NeilBrown wrote:
> > On Fri, June 26, 2009 10:50 pm, Jens Axboe wrote:
> >> On Fri, Jun 26 2009, Neil Brown wrote:
> >
> >>> But for now, please please please can we revert the change which made
> >>> 'queue' appear in md and dm devices, (and loop and ...) and put these
> >>> generic values somewhere ... generic?
> >>
> >> No we cannot, not without a time machine. 2.6.30 is released, so it's
> >> too late to revert things like that, even if we wanted.
> >
> > Drat... for some reason I was thinking that it only came in in 2.6.31-rc.
> > However it is only documented in ABI/testing, not ABI/stable ... if there
> > is any value in that distinction, then it should be possible to move it??
> >
> 
> No, wait.  I was right.  The addition of 'queue' to md/dm devices
> happened post-2.6.30.   So are the additions of physical_block_size etc.
> So there is still time to put these in a properly generic place.

Yes you are right, the commit date had me fooled.

> Do you have a good reason for them going in /queue?

Do you have a good reason for moving them? Im my opinion that makes the
separation between ->make_request_fn and ->request_fn devices bigger.

-- 
Jens Axboe

