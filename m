From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] Always do write-protect check
Date: Fri, 09 Dec 2005 12:51:30 -0500
Message-ID: <1134150691.3489.1.camel@mulgrave>
References: <Pine.LNX.4.44L0.0512091132050.6477-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:48034 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S964819AbVLIRvi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Dec 2005 12:51:38 -0500
In-Reply-To: <Pine.LNX.4.44L0.0512091132050.6477-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, "Salyzyn, Mark" <mark_salyzyn@adaptec.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Dmitry Antipov <antipov@ru.mvista.com>

On Fri, 2005-12-09 at 11:34 -0500, Alan Stern wrote:
> Since nobody has offered an explanation for why the sd driver makes a 
> write-protect check only for devices with removable media, I'm submitting 
> this patch (as620) to get rid of the removable-media test.

OK ... I'll put this in scsi-misc for post 2.6.15.  I suspect the reason
is that many devices get confused or lie about it, but there's only one
sure way to ascertain if this is true or not ...

If it turns out to be a problem, I'll back it out before 2.6.16.

James


