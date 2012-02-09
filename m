From: Jesper Juhl <jj@chaosbits.net>
Subject: Re: [patch 1/4] drivers/scsi/aacraid/commctrl.c: fix mem leak in
 aac_send_raw_srb()
Date: Thu, 9 Feb 2012 22:30:05 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1202092229040.32491@swampdragon.chaosbits.net>
References: <20120208205221.A66E4A03DE@akpm.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from swampdragon.chaosbits.net ([90.184.90.115]:26125 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754346Ab2BIV33 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Feb 2012 16:29:29 -0500
In-Reply-To: <20120208205221.A66E4A03DE@akpm.mtv.corp.google.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, mark_salyzyn@xyratex.com

On Wed, 8 Feb 2012, akpm@linux-foundation.org wrote:

> From: Jesper Juhl <jj@chaosbits.net>
> Subject: drivers/scsi/aacraid/commctrl.c: fix mem leak in aac_send_raw_srb()
> 

Linus already took this into his tree as commit 
7dd72f5189b257f927cc3b35d98643a5c392f5c3 , so you can drop it from your 
queue.


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

