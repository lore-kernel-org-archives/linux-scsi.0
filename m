From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [PATCHSET v3.1 0/7] data integrity: Stabilize pages during writeback for various fses
Date: Wed, 11 May 2011 01:28:32 +0900
Message-ID: <87vcxipljj.fsf@devron.myhome.or.jp>
References: <20110509230318.19566.66202.stgit@elm3c44.beaverton.ibm.com>
	<87tyd31fkc.fsf@devron.myhome.or.jp>
	<20110510123819.GB4402@quack.suse.cz>
	<87hb924s2x.fsf@devron.myhome.or.jp>
	<20110510132953.GE4402@quack.suse.cz>
	<878vue4qjb.fsf@devron.myhome.or.jp>
	<87zkmu3b2i.fsf@devron.myhome.or.jp>
	<20110510145421.GJ4402@quack.suse.cz>
	<87zkmupmaq.fsf@devron.myhome.or.jp>
	<20110510162237.GM4402@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-ext4-owner@vger.kernel.org>
In-Reply-To: <20110510162237.GM4402@quack.suse.cz> (Jan Kara's message of
	"Tue, 10 May 2011 18:22:37 +0200")
Sender: linux-ext4-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>, Theodore Tso <tytso@mit.edu>, Alexander Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jeff Layton <jlayton@redhat.com>, Dave Chinner <david@fromorbit.com>, linux-kernel <linux-kernel@vger.kernel.org>, Dave Hansen <dave@linux.vnet.ibm.com>, Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org, Chris Mason <chris.mason@oracle.com>, Joel Becker <jlbec@evilplan.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4@vger.kernel.org, Mingming Cao <mcao@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Jan Kara <jack@suse.cz> writes:

>> Maybe possible, but you really think on usual case just blocking is
>> better?
>   Define usual case... As Christoph noted, we don't currently have a real
> practical case where blocking would matter (since frequent rewrites are
> rather rare). So defining what is usual when we don't have a single real
> case is kind of tough ;)

OK. E.g. usual workload on desktop, but FS like ext2/fat.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
