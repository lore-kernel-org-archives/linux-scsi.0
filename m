From: Jens Axboe <axboe@suse.de>
Subject: Re: block layer sg, bsg
Date: Wed, 4 Aug 2004 17:04:04 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040804150403.GU10340@suse.de>
References: <20040804085000.GH10340@suse.de> <20040804075215.155c06ac.davem@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:47513 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S266242AbUHDPER (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Aug 2004 11:04:17 -0400
Content-Disposition: inline
In-Reply-To: <20040804075215.155c06ac.davem@redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: "David S. Miller" <davem@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, Aug 04 2004, David S. Miller wrote:
> 
> When you pass data structures in via {read,write}{,v}() system calls,
> you make it next to impossible for the CONFIG_COMPAT layer to cope
> with this.
> 
> Please consider another way to pass in those sg_io_* things.

Any suggestions?

-- 
Jens Axboe

