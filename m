From: Andrew Morton <akpm@osdl.org>
Subject: Re: [SCSI] Driver broken in 2.6.x?
Date: Sun, 29 May 2005 18:07:47 -0700
Message-ID: <20050529180747.18b7fd9e.akpm@osdl.org>
References: <424EB65A.8010600@punkt.pl>
	<20050525214047.731f56ef.akpm@osdl.org>
	<4298FD42.10608@punkt.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fire.osdl.org ([65.172.181.4]:50901 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S261491AbVE3BIo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 May 2005 21:08:44 -0400
In-Reply-To: <4298FD42.10608@punkt.pl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: |TEcHNO| <techno@punkt.pl>
Cc: linux-scsi@vger.kernel.org

|TEcHNO| <techno@punkt.pl> wrote:
>
> Hi,
> 
> > Is this crash still repeatable in 2.6.12-rc5?
> > 
> > If so, can you please verify that it still occurs if the nvidia driver was
> > never loaded?
> 
> No, it works now as if it was 2.4.x series.
> Now it just randomly hangs the system, ie. somewhere at the end of 
> scanning or suchm no nothing in logs or similar. Simply hangs. My guess 
> is that It shoudln't, no matter what, I always thought Linux was stable 
> but the current problems (CDburning problems around 2.6.9, scanner/SCSI 
> hanging the system) seem to  contradict this. That's bad.

You cunningly removed linux-scsi from cc and replaced it with linux-kernel.
Please don't do that.

As things have changed we'd need a new bug description please.

Please provide more details about the "hang".

Under what circumstances? 

Does it oops?

What hardware and which driver?

After it has "hung" is any information available from sysrq-P or sysrq-T?

Thanks.
