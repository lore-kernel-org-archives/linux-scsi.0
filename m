From: Jens Axboe <axboe@suse.de>
Subject: Re: smp dead lock of io_request_lock/queue_lock patch
Date: Mon, 12 Jan 2004 10:19:03 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040112091903.GD24638@suse.de>
References: <4002CC23.6000105@exavio.com.cn> <1073898527.4428.1.camel@laptop.fenrus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:40408 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S266102AbUALJT2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Jan 2004 04:19:28 -0500
Content-Disposition: inline
In-Reply-To: <1073898527.4428.1.camel@laptop.fenrus.com>
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjanv@redhat.com>
Cc: Peter Yao <peter@exavio.com.cn>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, Jan 12 2004, Arjan van de Ven wrote:
> On Mon, 2004-01-12 at 17:32, Peter Yao wrote:
> > Hi,
> > I found a smp dead lock in io_request_lock/queue_lock patch in redhat's
> > 2.4.18-4 kernel. 
> 
> 1) Bugs in vendor kernels are best reported to the vendor, in this case
> in http://bugzilla.redhat.com
> 2) 2.4.18-4 is really old and has been superceeded by updates a few
> dozen times
> 3) 2.4.18-4 has both remote and local security issues and datacorruption
> issues

4) The problem reported and patch looks real, though, maybe a little
credit and thanks would be appropriate as well?

-- 
Jens Axboe

