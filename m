From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH/RFC v3] allow userspace to modify scsi command filter
 on per device basis
Date: Wed, 18 Jun 2008 05:14:47 +0900
Message-ID: <20080618051447L.fujita.tomonori@lab.ntt.co.jp>
References: <6cf6b73e0806152249r19cb405ct9d5a33960e619348@mail.gmail.com>
	<20080616151328Q.fujita.tomonori@lab.ntt.co.jp>
	<6cf6b73e0806160222g19d7229dl6a650e13ab36c03b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:58232 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819AbYFQURS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jun 2008 16:17:18 -0400
In-Reply-To: <6cf6b73e0806160222g19d7229dl6a650e13ab36c03b@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: adel.gadllah@gmail.com
Cc: fujita.tomonori@lab.ntt.co.jp, matthew@wil.cx, linux-scsi@vger.kernel.org, pjones@redhat.com, jens.axboe@oracle.com, dgilbert@interlog.com

From: "Adel Gadllah" <adel.gadllah@gmail.com>
Subject: [PATCH/RFC v3] allow userspace to modify scsi command filter on per device basis
Date: Mon, 16 Jun 2008 11:22:56 +0200

> 2008/6/16 FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>:
> > No, sg has own command filtering mechanism, see sg_allow_access().
> >
> > When we discussed the per-gendisk command filter before, I think that
> > we agreed that we had better to have one command filtering mechanism.
> 
> The attached patch converts sg to use the cmd_filter too.
> The sg driver seems to verify commands for read access only. I have

sg driver lets you perform any command if you have the write
permission.


> not changed this behaviour to avoid breaking things (userspace),
> but if we want to change this I can submit another patch.

Well, this changes sg behaviour since sg's allow_ops filter has a
access permission different from blk_verify_command filter's.

I guess that the first thing you need to do is that figuring out a
proper access permission for each command, which sg maintainer, etc
can agree. It's pretty hard and that's the reason why this patch has
not been merged for years, I think.
