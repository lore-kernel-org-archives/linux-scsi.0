From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v4] sg: relax 16 byte cdb restriction
Date: Tue, 17 Dec 2013 12:21:04 -0800
Message-ID: <1387311664.2213.73.camel@dabdike.int.hansenpartnership.com>
References: <529B6044.9010809@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:38789 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752645Ab3LQUVG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Dec 2013 15:21:06 -0500
In-Reply-To: <529B6044.9010809@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Sun, 2013-12-01 at 17:13 +0100, Douglas Gilbert wrote:
> ChangeLog:
>          - remove the 16 byte CDB (SCSI command) length limit
>            from the sg driver by handling longer CDBs the same
>            way as the bsg driver. Remove comment from sg.h
>            public interface about the cmd_len field being
>            limited to 16 bytes.
>          - remove some dead code caused by this change
>          - cleanup comment block at the top of sg.h, fix urls
> 
> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>

This doesn't apply:

patching file drivers/scsi/sg.c
Hunk #1 succeeded at 74 (offset 1 line).
Hunk #2 succeeded at 164 (offset 2 lines).
Hunk #3 succeeded at 569 (offset -5 lines).
Hunk #4 FAILED at 606.
Hunk #5 succeeded at 678 (offset -6 lines).
Hunk #6 FAILED at 1660.
Hunk #7 succeeded at 1742 (offset -11 lines).
2 out of 7 hunks FAILED -- saving rejects to file drivers/scsi/sg.c.rej

It looks like there's a missing intermediate patch changing the way
logging is done within the driver ... I don't recall seeing such a patch
on the list.

James


