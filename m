From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/2][v2] blk-plug: don't flush nested plug lists
Date: Wed, 8 Apr 2015 18:13:55 +0200
Message-ID: <20150408161355.GA16052@lst.de>
References: <1428347694-17704-1-git-send-email-jmoyer@redhat.com> <1428347694-17704-2-git-send-email-jmoyer@redhat.com> <x49wq1nrcoe.fsf_-_@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <x49wq1nrcoe.fsf_-_@segfault.boston.devel.redhat.com>
Sender: owner-linux-mm@kvack.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Ming Lei <tom.leiming@gmail.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Roger Pau Monn?? <roger.pau@citrix.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Neil Brown <neilb@suse.de>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.cz>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>, Steven Whitehouse <swhiteho@redhat.com>, Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mgorman@suse.de>, Trond Myklebust <trond.myklebust@primarydata.com>Anna Schumaker <ann>
List-Id: linux-scsi@vger.kernel.org

This looks good, but without the blk_finish_plug argument we're bound
to grow programming mistakes where people forget it.  Any chance we
could have annotations similar to say rcu_read_lock/rcu_read_unlock
or the spinlocks so that sparse warns about it?

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
