From: "David S. Miller" <davem@redhat.com>
Subject: Re: block layer sg, bsg
Date: Wed, 4 Aug 2004 08:44:29 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040804084429.7de77cd7.davem@redhat.com>
References: <20040804085000.GH10340@suse.de>
	<20040804075215.155c06ac.davem@redhat.com>
	<20040804150403.GU10340@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:57041 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S266141AbUHDPqh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Aug 2004 11:46:37 -0400
In-Reply-To: <20040804150403.GU10340@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, 4 Aug 2004 17:04:04 +0200
Jens Axboe <axboe@suse.de> wrote:

> On Wed, Aug 04 2004, David S. Miller wrote:
> > 
> > When you pass data structures in via {read,write}{,v}() system calls,
> > you make it next to impossible for the CONFIG_COMPAT layer to cope
> > with this.
> > 
> > Please consider another way to pass in those sg_io_* things.
> 
> Any suggestions?

ioctl() :-(

Or use a more portable well-defined type which does not change
size nor layout between 32-bit and 64-bit environments.
