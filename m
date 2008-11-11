From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: best userspace iscsi target lib?
Date: Tue, 11 Nov 2008 12:55:34 +0200
Message-ID: <491964A6.8020309@panasas.com>
References: <4918B5B2.8050003@garzik.org> <20081111152229J.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:32910 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755244AbYKKKzW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Nov 2008 05:55:22 -0500
In-Reply-To: <20081111152229J.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: jeff@garzik.org, linux-scsi@vger.kernel.org

FUJITA Tomonori wrote:
> On Mon, 10 Nov 2008 17:29:06 -0500
> Jeff Garzik <jeff@garzik.org> wrote:
> 
>> Can someone recommend an open source userspace library that enables one 
>> to implement a userspace iSCSI target?
> 
> I'm not sure there is an open source userspace library enables you to
> easily implement your own userspace iSCSI target but there are some
> userspace iSCSI target implementations, which might useful.
> 
> Some Linux distributions use:
> 
> http://stgt.berlios.de/
> 

Look in this patch how we added an external OSD scsi-implementor to stgt:
http://git.open-osd.org/gitweb.cgi?p=osc-osd/tgt/.git;a=commitdiff;h=5f3b25ef217ee417d8afe255d1a9bc5ed7f25f79
The implementation itself is in an external library.

I find stgt very easy to be extended.

<snip>

Boaz
