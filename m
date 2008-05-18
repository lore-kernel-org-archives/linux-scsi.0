From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: [BUG] unable to handle kernel paging request in next-20080516
 (scsi_bus_uevent)
Date: Sun, 18 May 2008 11:22:06 +0000 (UTC)
Message-ID: <g0p3gu$3gh$1@ger.gmane.org>
References: <g0mkaf$i1r$1@ger.gmane.org>
	<20080518021423.3dcf0ddd.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756983AbYERLW0@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, 18 May 2008 02:14:23 -0700, Andrew Morton wrote:

> (cc's added)
> 
> On Sat, 17 May 2008 12:50:24 +0000 (UTC) Sitsofe Wheeler
> 
>> Sometimes when booting next-20080516 on Ubuntu Gutsy an oops then a
>> panic will occur. At first I thought it might be provoked by vga=0x164
>> but this does not appear to be the case and the issue is seemingly
>> random. I've hand transcribed the oops so there may be errors in it but
>> hopefully it will still help:
>> 
>> BUG: unable to handle kernel paging request at e6f17fac IP:
>> [<c02604d6>] scsi_bus_uevent+0x1/0x17 *pde = 2714b163 *pte = 26f17160
>> Oops: 0000 [#1] DEBUG_PAGEALLOC
>> last sysfs file:
>> 
> I thought we'd already fixed this?

Thanks to your tip off I've found that this bug is already in bugzilla 
(complete with the commit that caused the regression) - http://
bugzilla.kernel.org/show_bug.cgi?id=10711 . There's nothing there that 
says it has been fixed though. I'll look harder before reporting problems 
next time.

-- 
Sitsofe | http://sucs.org/~sits/
