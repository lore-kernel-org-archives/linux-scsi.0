From: Mark Haverkamp <markh@osdl.org>
Subject: Re: [PATCH] aacraid: fix integer constant warning
Date: Tue, 16 Nov 2004 16:05:24 -0800
Message-ID: <1100649924.27066.57.camel@markh1.pdx.osdl.net>
References: <419A899B.6010401@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fire.osdl.org ([65.172.181.4]:5258 "EHLO fire-1.osdl.org")
	by vger.kernel.org with ESMTP id S261898AbUKQAF1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Nov 2004 19:05:27 -0500
In-Reply-To: <419A899B.6010401@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Randy.Dunlap" <rddunlap@osdl.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>

On Tue, 2004-11-16 at 15:13 -0800, Randy.Dunlap wrote:
> drivers/scsi/aacraid/aachba.c:1140: warning: integer constant is too 
> large for "long" type
> 
> diffstat:=
>   drivers/scsi/aacraid/aachba.c |    2 +-
>   1 files changed, 1 insertion(+), 1 deletion(-)
> 
> Signed-off-by: Randy Dunlap <rddunlap@osdl.org>

This is fixed as part of a recent patch that I submitted on Oct 21
titled [PATCH] 2.6.9 aacraid: Support ROMB RAID/SCSI mode

Mark.

-- 
Mark Haverkamp <markh@osdl.org>

