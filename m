From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Alternative TRIM proposal
Date: Tue, 7 Oct 2008 13:39:31 +0200
Message-ID: <20081007113931.GU19428@kernel.dk>
References: <200810021732.m92HW7qL015836@coles02.co.lsil.com> <OF93179061.8BBD23CF-ON862574D6.006C600D-862574D6.006E8EBB@seagate.com> <20081003154237.GT13822@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pasmtpb.tele.dk ([80.160.77.98]:36757 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753007AbYJGLkB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Oct 2008 07:40:01 -0400
Content-Disposition: inline
In-Reply-To: <20081003154237.GT13822@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Gerry.Houlder@seagate.com, dougg@torque.net, "Knight, Frederick" <Frederick.Knight@netapp.com>, linux-scsi@vger.kernel.org, t10@t10.org, David Woodhouse <dwmw2@infradead.org>

On Fri, Oct 03 2008, Matthew Wilcox wrote:
> It is today the case in Linux that each extent will be sent from the
> filesystem to the block layer individually.  I can't speak to other
> operating systems, maybe some of them allow filesystems to send a list
> of extents to the SCSI layer, maybe their SCSI layer can take extents
> out of the queue and bundle them together into a single command.

We do that for lots of regular IO as well, but still support merging
them into a single command - the same could be done for trim, basically
making any of them mergable into a single command.

-- 
Jens Axboe

