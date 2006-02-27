From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] Export spi_populate_* functions
Date: Mon, 27 Feb 2006 08:47:42 -0600
Message-ID: <1141051662.3228.1.camel@mulgrave.il.steeleye.com>
References: <20060227141826.GB27759@parisc-linux.org>
	 <1141050699.2992.113.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:43684 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751266AbWB0Orz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Feb 2006 09:47:55 -0500
In-Reply-To: <1141050699.2992.113.camel@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org

On Mon, 2006-02-27 at 15:31 +0100, Arjan van de Ven wrote:
> since this is new and very much linux specific code, shouldn't these be
> _GPL exports?

Actually, try this commit:

http://www.kernel.org/git/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commit;h=e855d0f4b3d4c421d4de5f30582e3aa579184adb

It's been there since I put the patch in ... otherwise none of my
modules would build ...

James


