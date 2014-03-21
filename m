From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC PATCH 0/5] userspace PI passthrough via AIO/DIO
Date: Fri, 21 Mar 2014 14:39:59 -0700
Message-ID: <20140321213959.GC5437@birch.djwong.org>
References: <20140321043041.8428.79003.stgit@birch.djwong.org>
 <x49wqfny4ys.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <x49wqfny4ys.fsf@segfault.boston.devel.redhat.com>
Sender: owner-linux-aio@kvack.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: axboe@kernel.dk, martin.petersen@oracle.com, JBottomley@parallels.com, bcrl@kvack.org, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, linux-aio@kvack.org, linux-scsi@vger.kernel.org, linux-mm@kvack.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Mar 21, 2014 at 10:57:31AM -0400, Jeff Moyer wrote:
> "Darrick J. Wong" <darrick.wong@oracle.com> writes:
> 
> > This RFC provides a rough implementation of a mechanism to allow
> > userspace to attach protection information (e.g. T10 DIF) data to a
> > disk write and to receive the information alongside a disk read.  The
> > interface is an extension to the AIO interface: two new commands
> > (IOCB_CMD_P{READ,WRITE}VM) are provided.  The last struct iovec in the
> 
> Sorry for the shallow question, but what does that M stand for?

Hmmm... I really don't remember why I picked 'M'.  Probably because it implied
that the IO has extra 'M'etadata associated with it.

But now I see, 'VM' connotes something entirely wrong.

--D
> 
> Cheers,
> Jeff

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
