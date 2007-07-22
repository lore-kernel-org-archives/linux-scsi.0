From: Gabriel C <nix.or.die@googlemail.com>
Subject: Re: drivers/scsi/sym53c416.c - address of 'sym53c416*' will always
 evaluate as 'true' , warnings
Date: Sun, 22 Jul 2007 18:38:10 +0200
Message-ID: <46A387F2.5050704@googlemail.com>
References: <46A36115.3070600@googlemail.com> <20070722162334.GA26883@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.191]:46845 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755264AbXGVQk2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Jul 2007 12:40:28 -0400
Received: by mu-out-0910.google.com with SMTP id i10so2224801mue
        for <linux-scsi@vger.kernel.org>; Sun, 22 Jul 2007 09:40:26 -0700 (PDT)
In-Reply-To: <20070722162334.GA26883@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Lieven Willems <lw_linux@hotmail.com>, Alan Cox <alan@redhat.com>, linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> On Sun, Jul 22, 2007 at 03:52:21PM +0200, Gabriel C wrote:
>> drivers/scsi/sym53c416.c: In function 'sym53c416_detect':
>> drivers/scsi/sym53c416.c:638: warning: the address of 'sym53c416' will always evaluate as 'true'
>> drivers/scsi/sym53c416.c:644: warning: the address of 'sym53c416_1' will always evaluate as 'true'
>> drivers/scsi/sym53c416.c:650: warning: the address of 'sym53c416_2' will always evaluate as 'true'
>> drivers/scsi/sym53c416.c:656: warning: the address of 'sym53c416_3' will always evaluate as 'true'
> 
> These warnings certainly indicate a problem; I've looked through the
> driver and it's a bit of a mess.  Do you have one of these cards?  I can
> write and send you some patches to test on Monday or Tuesday, after I'm
> done with the advansys driver.
> 

Sorry , I don't have these cards :/


Regards,

Gabriel
