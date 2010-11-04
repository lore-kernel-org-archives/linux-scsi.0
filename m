From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: Linux 2.6.37-rc1 (scsi_debug: list corruption)
Date: Thu, 04 Nov 2010 09:12:21 -0700
Message-ID: <4CD2DB65.5060400@oracle.com>
References: <AANLkTimr3rW67HxgOUyReEW8dmmSsd4b7-Ns57mXzS1w@mail.gmail.com>	<20101103162015.99475a0b.randy.dunlap@oracle.com> <AANLkTin5PphTtZaesEU3U0PA8NJv=Jmis8yQF6b=KbeG@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:27285 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759Ab0KDQMm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Nov 2010 12:12:42 -0400
In-Reply-To: <AANLkTin5PphTtZaesEU3U0PA8NJv=Jmis8yQF6b=KbeG@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Xiaotian Feng <xtfeng@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, scsi <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On 11/03/10 19:25, Xiaotian Feng wrote:
> On Thu, Nov 4, 2010 at 7:20 AM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>>
>>
>> [  102.555847] calling  scsi_debug_init+0x0/0x704 [scsi_debug] @ 3337
>> Nov  3 16:06:12 control kernel: [  102.555847] calling  scsi_deb[  102.622974] scsi_debug: host protection
>> [  102.627513] scsi4 : scsi_debug, version 1.82 [20100324], dev_size_mb=8, opts=0x0
>> Nov  3 16:06:13 control kernel: [  102.639095] initcall scsi_debug_init+0x0/0x704 [scsi_debug] returned 0 after 75039 usecs
>> Nov  3 16:06:13 [  102.651072] ------------[ cut here ]------------
>> [  102.657373] WARNING: at /local/linsrc/lnx-2637-rc1/lib/list_debug.c:26 __list_add+0x4d/0xa5()
>> [  102.666012] Hardware name: OptiPlex GX620
>> [  102.671396] list_add corruption. next->prev should be prev (ffffffff81ae5e50), but was 6b6b6b6b6b6b6b6b. (next=ffff88006c880590).
> 
> This might be related with net rds percpu_counter corruption. Does
> following patch fix your issue?
> http://patchwork.ozlabs.org/patch/69939/

Yes, somehow that patch fixes it.

What good eyes you have.

thanks,
-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
