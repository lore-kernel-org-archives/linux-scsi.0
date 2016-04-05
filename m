From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 03/12] BUG: Losing bits on request.cmd_flags
Date: Mon, 04 Apr 2016 22:08:50 -0400
Message-ID: <yq1zit8bydp.fsf@sermon.lab.mkp.net>
References: <1459746376-27983-1-git-send-email-shaun@tancheff.com>
	<1459746376-27983-4-git-send-email-shaun@tancheff.com>
	<x49pou5s6yg.fsf@segfault.boston.devel.redhat.com>
	<CAJVOszAK5w4qsrKcUot8rm9nZ65hXeUm5YomQU3fT-fARCGXjA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAJVOszAK5w4qsrKcUot8rm9nZ65hXeUm5YomQU3fT-fARCGXjA@mail.gmail.com>
	(Shaun Tancheff's message of "Mon, 4 Apr 2016 23:06:03 +0700")
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Shaun Tancheff <shaun.tancheff@seagate.com>
Cc: Jens Axboe <axboe@fb.com>, linux-scsi@vger.kernel.org, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-ide@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>, Shaun Tancheff <shaun@tancheff.com>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Shaun" == Shaun Tancheff <shaun.tancheff@seagate.com> writes:

Shaun> Oh, okay. It became an issue in the next patch where some
Shaun> internal cmd_flags temporaries where stored in 32 bit values.

Shaun> I will fix patch/subject.

There's a pending patch set from Mike Christie that cleans all this
up. Please use that as baseline.

-- 
Martin K. Petersen	Oracle Linux Engineering
