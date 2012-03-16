From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: WARNING: at block/genhd.c:1474 __disk_unblock_events+0xe1/0xf0()
 -- should I be concerned?
Date: Sat, 17 Mar 2012 02:27:34 +0400
Message-ID: <4F63BE56.2080608@msgid.tls.msk.ru>
References: <4F5379F5.6010604@msgid.tls.msk.ru> <4F545EB5.1070700@msgid.tls.msk.ru> <4F54FE51.1010401@acm.org> <4F5F6E34.6070208@msgid.tls.msk.ru> <4F60EAAE.3070803@acm.org> <4F611634.804@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from isrv.corpit.ru ([86.62.121.231]:58806 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754554Ab2CPW1g (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Mar 2012 18:27:36 -0400
In-Reply-To: <4F611634.804@msgid.tls.msk.ru>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On 15.03.2012 02:05, Michael Tokarev wrote:
> On 14.03.2012 22:59, Bart Van Assche wrote:
>> On 03/13/12 15:56, Michael Tokarev wrote:
>>> WARNING: at block/genhd.c:1474 __disk_unblock_events+0x123/0x130()

The original issue is fixed for me by the following:

commit 9f53d2fe815b4011ff930a7b6db98385d45faa68
Author: Stanislaw Gruszka <sgruszka@redhat.com>
Date:   Fri Mar 2 10:43:28 2012 +0100

    block: fix __blkdev_get and add_disk race condition

Thanks,

/mjt
