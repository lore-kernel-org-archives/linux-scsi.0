From: Jens Axboe <axboe@suse.de>
Subject: Re: smp dead lock of io_request_lock/queue_lock patch
Date: Mon, 12 Jan 2004 10:22:31 +0100
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20040112092231.GG29177@suse.de>
References: <4002CC23.6000105@exavio.com.cn> <1073898527.4428.1.camel@laptop.fenrus.com> <20040112091903.GD24638@suse.de> <20040112091946.GA29779@suse.de> <20040112092059.GC6677@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20040112092059.GC6677@devserv.devel.redhat.com>
To: Arjan van de Ven <arjanv@redhat.com>
Cc: Peter Yao <peter@exavio.com.cn>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Jan 12 2004, Arjan van de Ven wrote:
> On Mon, Jan 12, 2004 at 10:19:46AM +0100, Jens Axboe wrote:
> > 
> > ... and still exists in your 2.4.21 based kernel.
> 
> The RHL 2.4.21 kernels don't have the locking patch at all...

But RHEL3 does:

http://kernelnewbies.org/kernels/rhel3/SOURCES/linux-2.4.21-iorl.patch

and the bug is there.

-- 
Jens Axboe
