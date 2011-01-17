From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] target_core_mib.h move
Date: Mon, 17 Jan 2011 14:32:38 -0800
Message-ID: <1295303558.22813.241.camel@haakon2.linux-iscsi.org>
References: <AANLkTim-KKyOt_U2cDvfW3cav9F29mSvzAcV9H2mJqbT@mail.gmail.com>
	 <20110117205130.GA22532@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:37979 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052Ab1AQWcl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Jan 2011 17:32:41 -0500
In-Reply-To: <20110117205130.GA22532@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Fubo Chen <fubo.chen@gmail.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Mon, 2011-01-17 at 15:51 -0500, Christoph Hellwig wrote:
> On Mon, Jan 17, 2011 at 09:00:02PM +0100, Fubo Chen wrote:
> > target_core_mib.h move from drivers/target to include/target.
> > Otherwise my driver not build.
> > 
> > Signed-off-by: Fubo Chen <fubo.chen@gmail.com>
> 
> Why does the driver need to poke into the target MIB code directly?
> 
> Can you post the driver?
> 

I assume this is for an old out-of-tree version of iscsi_target_mod.ko..

Fubo, if you want to test and ship mainline target code please use what
will be tagged as .38-rc1 in lio-core-2.6.git/linus-38-rc1 with the
offical LIO-Target iSCSI fabric module.  Otherwise please do not send
target patches to linux-scsi for compat with old out-of-tree LIO iSCSI
fabric module code.

Thanks!

--nab


