From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: drivers/scsi/sym53c416.c - address of 'sym53c416*' will always evaluate as 'true' , warnings
Date: Sun, 22 Jul 2007 10:23:34 -0600
Message-ID: <20070722162334.GA26883@parisc-linux.org>
References: <46A36115.3070600@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:42664 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341AbXGVQXg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Jul 2007 12:23:36 -0400
Content-Disposition: inline
In-Reply-To: <46A36115.3070600@googlemail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gabriel C <nix.or.die@googlemail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Lieven Willems <lw_linux@hotmail.com>, Alan Cox <alan@redhat.com>, linux-scsi@vger.kernel.org

On Sun, Jul 22, 2007 at 03:52:21PM +0200, Gabriel C wrote:
> drivers/scsi/sym53c416.c: In function 'sym53c416_detect':
> drivers/scsi/sym53c416.c:638: warning: the address of 'sym53c416' will always evaluate as 'true'
> drivers/scsi/sym53c416.c:644: warning: the address of 'sym53c416_1' will always evaluate as 'true'
> drivers/scsi/sym53c416.c:650: warning: the address of 'sym53c416_2' will always evaluate as 'true'
> drivers/scsi/sym53c416.c:656: warning: the address of 'sym53c416_3' will always evaluate as 'true'

These warnings certainly indicate a problem; I've looked through the
driver and it's a bit of a mess.  Do you have one of these cards?  I can
write and send you some patches to test on Monday or Tuesday, after I'm
done with the advansys driver.

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
