From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] SCSI tape: add MTWEOFI to write filemarks without
 flushing drive buffer
Date: Thu, 07 Oct 2010 17:54:47 -0400
Message-ID: <1286488487.23573.1.camel@mulgrave.site>
References: <alpine.LNX.2.00.1008291828080.8430@kai.makisara.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:36708 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042Ab0JHFBx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Oct 2010 01:01:53 -0400
In-Reply-To: <alpine.LNX.2.00.1008291828080.8430@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Sun, 2010-08-29 at 18:45 +0300, Kai Makisara wrote:
> This patch adds a new MTIOCTOP operation MTWEOFI that writes filemarks with
> immediate bit set. This means that the drive does not flush its buffer and the
> next file can be started immediately. This speeds up writing in applications
> that have to write multiple small files.

This patch is rejecting massively ... could you respin it against
scsi-misc, please?

jejb@mulgrave:~/git/scsi-misc-2.6> patch -p1 < ~/tmp.mail
patching file drivers/scsi/st.c
Hunk #1 FAILED at 9.
Hunk #2 succeeded at 17 with fuzz 2.
Hunk #3 FAILED at 2696.
Hunk #4 FAILED at 2883.
Hunk #5 FAILED at 2901.
4 out of 5 hunks FAILED -- saving rejects to file drivers/scsi/st.c.rej
patching file include/linux/mtio.h
Hunk #1 FAILED at 63.
1 out of 1 hunk FAILED -- saving rejects to file include/linux/mtio.h.rej
patching file Documentation/scsi/st.txt
Hunk #1 succeeded at 2 with fuzz 2.
Hunk #2 FAILED at 85.
Hunk #3 FAILED at 301.
2 out of 3 hunks FAILED -- saving rejects to file Documentation/scsi/st.txt.rej

Thanks,

James


