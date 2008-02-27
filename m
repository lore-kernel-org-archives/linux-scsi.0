From: "nickcheng" <nick.cheng@areca.com.tw>
Subject: RE: arcmsr & areca-1660 - strange behaviour under heavy load
Date: Wed, 27 Feb 2008 09:53:28 +0800
Message-ID: <000c01c878e3$8c561460$8800a8c0@Nick>
References: <1204059852.665822.13.camel@localhost>
Reply-To: <nick.cheng@areca.com.tw>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.areca.com.tw ([220.130.178.143]:60381 "EHLO areca.com.tw"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757483AbYB0Bxf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Feb 2008 20:53:35 -0500
In-Reply-To: <1204059852.665822.13.camel@localhost>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Nikola Ciprich' <extmaillist@linuxbox.cz>
Cc: 'Andrew Morton' <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, 'Erich Chen' <erich@areca.com.tw>, kopi@linuxbox.cz, support@areca.com.tw, 'Zan Lynx' <zlynx@acm.org>

Hi Nikola,
Please put support@areca.com.tw in the loop.
I am sure Areca support, Kevin, has taken over your case.
If you like, please let him know your configuration and operations to
synchronize both sides.
Thank you for your patience and sorry for your inconvenience,

-----Original Message-----
From: Zan Lynx [mailto:zlynx@acm.org] 
Sent: Wednesday, February 27, 2008 5:04 AM
To: Nikola Ciprich
Cc: Andrew Morton; linux-kernel@vger.kernel.org; linux-scsi@vger.kernel.org;
Nick Cheng; Erich Chen; kopi@linuxbox.cz
Subject: Re: arcmsr & areca-1660 - strange behaviour under heavy load


On Tue, 2008-02-26 at 20:29 +0100, Nikola Ciprich wrote:
> Hi Andrew,
> no, right now I have the machine in the weird state, swap is empty (3GB), 
> and so is bigger part of RAM (~100MB free), and the gcc crashes even when 
> trying to compile c program with empty main function. so it doesn't seem 
> to be problem with memory exhaustion.

Maybe memory fragmentation?  Perhaps the driver tries to allocate a
large block of memory and cannot find a continuous block of the right
size.

Maybe the driver developers used different kernel .config options than
you are using.  

Try increasing the value in /proc/sys/vm/min_free_kbytes.

Try switching some things like SLAB or SLUB, try booting with
kernelcore=512M to enable the Movable memory zone, or try 64-bit vs
32-bit kernels. 
-- 
Zan Lynx <zlynx@acm.org>

