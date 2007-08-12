From: Gabriel C <nix.or.die@googlemail.com>
Subject: Re: 2.6.23-rc2-mm2
Date: Sun, 12 Aug 2007 17:21:23 +0200
Message-ID: <46BF2573.20807@googlemail.com>
References: <20070809224254.11f42716.akpm@linux-foundation.org>	<46BC3CB1.2090503@googlemail.com>	<46BC5B75.80102@googlemail.com> <20070810093817.a9bec74f.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.186]:48552 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766AbXHLPXl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Aug 2007 11:23:41 -0400
Received: by mu-out-0910.google.com with SMTP id i10so1867172mue
        for <linux-scsi@vger.kernel.org>; Sun, 12 Aug 2007 08:23:40 -0700 (PDT)
In-Reply-To: <20070810093817.a9bec74f.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@SteelEye.com>

Andrew Morton wrote:
> On Fri, 10 Aug 2007 14:35:01 +0200 Gabriel C <nix.or.die@googlemail.com> wrote:
> 
>> In file included from include/linux/blkdev.h:17,
>>                  from kernel/sched.c:45:
>> include/linux/bsg.h:67: warning: 'struct request_queue' declared inside parameter list
>> include/linux/bsg.h:67: warning: its scope is only this definition or declaration, which is probably not what you want
>> include/linux/bsg.h:71: warning: 'struct request_queue' declared inside parameter list
> 
> Thanks, I'll fix that up.
> 

I just realized this problem exists in mainline too , introduced by this commit :

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=a4ee0df8b3d007f0d685d38a56dc0b91e01aaaf7;hp=2cd614c8732172524c36cd5245620338928062b6
