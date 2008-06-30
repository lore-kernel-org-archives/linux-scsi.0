From: "Erez Zilber" <erezzi.list@gmail.com>
Subject: Should a block device enforce block atomicity?
Date: Mon, 30 Jun 2008 09:51:16 +0300
Message-ID: <ce513bcc0806292351t7f4ad933l920112381f4ebb4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.230]:29454 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758122AbYF3GvS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jun 2008 02:51:18 -0400
Received: by rv-out-0506.google.com with SMTP id k40so1521044rvb.1
        for <linux-scsi@vger.kernel.org>; Sun, 29 Jun 2008 23:51:16 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Hi,

I have a question about block devices and whether they are required to
enforce block atomicity:

I read the code of drivers/block/brd.c, and I didn't see any locking
when blocks are read/written. I also looked at the block layer code
that calls brd and didn't find any locking there. Does it mean that
there's no block atomicity (i.e. multiple threads can write a single
block at the same time)? Is there any hidden assumption here? Is this
the responsibility of the application to do that (e.g. not start a
WRITE request before other READ/WRITE requests to the same block were
completed)?

Thanks,
Erez
