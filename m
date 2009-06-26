From: Neil Brown <neilb@suse.de>
Subject: Re: [dm-devel] REQUEST for new 'topology' metrics to be moved out  of the 'queue' sysfs directory.
Date: Fri, 26 Jun 2009 21:58:29 +1000
Message-ID: <19012.47077.328965.919868@notabene.brown>
References: <19010.62951.886231.96622@notabene.brown>
	<yq11vp8spxo.fsf@sermon.lab.mkp.net>
	<125b48b7ffc99a496fbdd512f38cada5.squirrel@neil.brown.name>
	<yq1k530qkm7.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: message from Martin K. Petersen on Thursday June 25
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Alasdair G Kergon <agk@redhat.com>, jens.axboe@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org, linux-fsdevel@vger.kernel.org, device-mapper development <dm-devel@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Thursday June 25, martin.petersen@oracle.com wrote:
> >>>>> "Neil" == NeilBrown  <neilb@suse.de> writes:
> 
> And just to make it clear: I completely agree with your argument that
> which knob to choose is I/O size dependent.  My beef with your proposal
> is that I believe the length of the list should be 2.

0, 1, or infinity are the only credible sizes for this sort of list.

However I feel I've written enough on this particular issue (the
particular meaning of the various fields, not the directory location
which I still feel strongly about).

Providing the fields are clearly and unambiguously documented so that
it I can use the documentation to verify the implementation (in md at
least), I will be satisfied.  And if the names of the files actually
match the documented meaning (so e.g. s/io/write/) I might even be
happy.

I'm looking forward to seeing how you justify the name
"physical_block_size" in a way the encompasses possibilities like a
device that stripes over a heterogeneous set of disk drives ;-)

Thanks,
NeilBrown
