From: Alberto Bertogli <albertogli@telpin.com.ar>
Subject: Re: [linux-usb-devel] BUG when removing USB flash drive
Date: Fri, 14 May 2004 18:55:01 -0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040514215501.GD10575@telpin.com.ar>
References: <1084565070.1841.373.camel@mulgrave> <Pine.LNX.4.44L0.0405141710290.20244-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.telpin.com.ar ([200.43.18.243]:2212 "EHLO
	mail.telpin.com.ar") by vger.kernel.org with ESMTP id S262961AbUENV4i
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 May 2004 17:56:38 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0405141710290.20244-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Mike Anderson <andmike@us.ibm.com>, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Fri, May 14, 2004 at 05:13:38PM -0400, Alan Stern wrote:
> I'll work on a patch.  Testing it won't be easy, though; it's hard to 
> prove that a race _isn't_ happening!

I'm going to have to repeat this tests a few more times (in fact, I'll
boot -mm2 in a couple of minutes to see if I can reproduce the bug there),
so if you want me to try some patch let me know. As you say, I can't
_prove_ it, but at least I can confirm I can't hit it =)

Thanks,
		Alberto


