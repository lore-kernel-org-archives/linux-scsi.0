From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] aic94xx: convert to request_firmware interface
Date: Mon, 28 Aug 2006 10:59:49 -0500
Message-ID: <1156780789.3465.13.camel@mulgrave.il.steeleye.com>
References: <20060828155254.64027.qmail@web31809.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:61077 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751133AbWH1P7w (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Aug 2006 11:59:52 -0400
In-Reply-To: <20060828155254.64027.qmail@web31809.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ltuikov@yahoo.com
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Mon, 2006-08-28 at 08:52 -0700, Luben Tuikov wrote:
> --- James Bottomley <James.Bottomley@SteelEye.com> wrote:
> 
> > Re: [PATCH] aic94xx: convert to request_firmware interface
> > This patch is too big to inline, so I attached it compressed.
> 
> This will not work.

It's currently working in my x86 system.

I haven't managed to test on a BE system yet to make sure I got all the
swaps correct, though.

James


