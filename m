From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [GIT PATCH] pending SCSI updates for post 2.6.16
Date: Wed, 22 Mar 2006 13:27:07 -0600
Message-ID: <1143055627.3629.1.camel@mulgrave.il.steeleye.com>
References: <1142956795.4377.19.camel@mulgrave.il.steeleye.com>
	 <20060322083647.cc0ccdd4.rdunlap@xenotime.net>
	 <Pine.LNX.4.64.0603221048210.26286@g5.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:1746 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932413AbWCVT2C (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Mar 2006 14:28:02 -0500
In-Reply-To: <Pine.LNX.4.64.0603221048210.26286@g5.osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>, akpm@osdl.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, 2006-03-22 at 10:49 -0800, Linus Torvalds wrote:
> Just something like this? Or did you have something else in mind?
> 
> (Pls test and ack).

That and a comment telling those who come after to keep scsi_debug at
the bottom of the driver list, I think, thanks.

James


