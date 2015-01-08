From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: scsi: non atomic allocation in mempool_alloc in atomic context
Date: Thu, 8 Jan 2015 12:31:36 -0800
Message-ID: <CAADnVQ+U5=DD555UqYM1gUQxWLE4qN=Xz1kJVHp=Zxmz3Z_ZJQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Sasha Levin <sasha.levin@oracle.com>, bvanassche <bvanassche@acm.org>, hare <hare@suse.de>, jbottomley <JBottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jan 8, 2015 at 1:29 AM, Christoph Hellwig <hch@lst.de> wrote:
> On Wed, Jan 07, 2015 at 07:55:42PM -0800, Alexei Starovoitov wrote:
>> I'm seeing the same splats... what tree I can pull the fix from ?
>
> None so far.  I'll still need a review to apply it to the scsi-queue tree.

applied it manually and warning is gone. It used to
spam a lot of them.
