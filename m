From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [RFC PATCH 0/5] userspace PI passthrough via AIO/DIO
Date: Fri, 21 Mar 2014 10:57:31 -0400
Message-ID: <x49wqfny4ys.fsf@segfault.boston.devel.redhat.com>
References: <20140321043041.8428.79003.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20140321043041.8428.79003.stgit@birch.djwong.org> (Darrick
	J. Wong's message of "Thu, 20 Mar 2014 21:30:41 -0700")
Sender: owner-linux-mm@kvack.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: axboe@kernel.dk, martin.petersen@oracle.com, JBottomley@parallels.com, bcrl@kvack.org, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, linux-aio@kvack.org, linux-scsi@vger.kernel.org, linux-mm@kvack.org
List-Id: linux-scsi@vger.kernel.org

"Darrick J. Wong" <darrick.wong@oracle.com> writes:

> This RFC provides a rough implementation of a mechanism to allow
> userspace to attach protection information (e.g. T10 DIF) data to a
> disk write and to receive the information alongside a disk read.  The
> interface is an extension to the AIO interface: two new commands
> (IOCB_CMD_P{READ,WRITE}VM) are provided.  The last struct iovec in the

Sorry for the shallow question, but what does that M stand for?

Cheers,
Jeff

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
