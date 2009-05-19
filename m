From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 05/13] block: Export I/O topology for block devices and
	partitions
Date: Tue, 19 May 2009 20:15:30 +0200
Message-ID: <20090519181530.GH4140@kernel.dk>
References: <1242362435-11953-1-git-send-email-martin.petersen@oracle.com> <1242362435-11953-6-git-send-email-martin.petersen@oracle.com> <20090518175741.GM4140@kernel.dk> <20090518181204.GC32085@redhat.com> <yq1fxf1gi3y.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <yq1fxf1gi3y.fsf@sermon.lab.mkp.net>
Sender: linux-ide-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Mike Snitzer <snitzer@redhat.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, May 19 2009, Martin K. Petersen wrote:
> >>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:
> 
> >> I really hate the 'alignment' name, nobody will know wtf that is
> >> without looking it up. The rest of the names are fairly self
> >> explanatory.  offset? offset_size? misalignment? Not very good with
> >> names, but perhaps we can find something more appropriate :-)
> 
> Yeah, it's a tricky thing to convey.  And despite all the other
> convergence otherwise happening in the standards, T10 and T13 do not
> agree how to describe the logical/physical alignment.
> 
> 
> Mike> I agree that 'alignment' is too terse/confusing given that it is
> Mike> an offset we're exposing.  How about 'alignment_offset'?
> 
> I thought I had already changed it to alignment_offset like we talked
> about a while ago.  But I guess that change was only done mentally :)
> 
> Jens, are you ok with that name?

I think so, I can't think of anything better :-)

If you repost an updated 5/13 patch and I'll add it to the mix.

-- 
Jens Axboe

