From: Jesper Juhl <juhl-lkml@dif.dk>
Subject: Re: [PATCH] fix inlining trouble causing build failure in
 drivers/scsi/qla2xxx/qla_os.c
Date: Mon, 20 Sep 2004 00:11:03 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.61.0409200008340.2758@dragon.hygekrogen.localhost>
References: <Pine.LNX.4.61.0409192346490.2758@dragon.hygekrogen.localhost>
 <1095631123.1717.20.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dif.dk ([193.138.115.101]:37541 "EHLO mail.dif.dk")
	by vger.kernel.org with ESMTP id S264531AbUISWEW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 19 Sep 2004 18:04:22 -0400
In-Reply-To: <1095631123.1717.20.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jesper Juhl <juhl-lkml@dif.dk>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Sun, 19 Sep 2004, James Bottomley wrote:

> On Sun, 2004-09-19 at 17:58, Jesper Juhl wrote:
> > 
> > 2.6.9-rc2-bk5 allyesconfig fails to build for me with gcc 3.4.1 with the 
> > following error : 
> 
> Actually, Adrian Bunk got there ahead of you.  The fix is in both the
> scsi-misc-2.6 tree and 2.6.9-rc2-mm1
> 
So I see. I didn't have 2.6.9-rc2-mm1 handy to check - I need to make that 
a habit.
Ohh well, as long as it gets fixed, that's the main thing. :)

/Jesper

