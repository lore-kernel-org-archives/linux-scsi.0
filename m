From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] Export spi_populate_* functions
Date: Mon, 27 Feb 2006 07:51:27 -0700
Message-ID: <20060227145127.GD27759@parisc-linux.org>
References: <20060227141826.GB27759@parisc-linux.org> <1141050699.2992.113.camel@laptopd505.fenrus.org> <1141051662.3228.1.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:28868 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S1751403AbWB0Ov2
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Feb 2006 09:51:28 -0500
Content-Disposition: inline
In-Reply-To: <1141051662.3228.1.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-scsi@vger.kernel.org

On Mon, Feb 27, 2006 at 08:47:42AM -0600, James Bottomley wrote:
> On Mon, 2006-02-27 at 15:31 +0100, Arjan van de Ven wrote:
> > since this is new and very much linux specific code, shouldn't these be
> > _GPL exports?
> 
> Actually, try this commit:
> 
> http://www.kernel.org/git/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commit;h=e855d0f4b3d4c421d4de5f30582e3aa579184adb
> 
> It's been there since I put the patch in ... otherwise none of my
> modules would build ...

How  strange; when I looked  on  gitweb an hour  ago,  it  wasn't
there,  yet  now it  is.  
