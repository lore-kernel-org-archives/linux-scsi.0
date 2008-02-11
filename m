From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: Integration of SCST in the mainstream Linux kernel
Date: Mon, 11 Feb 2008 13:02:47 +0300
Message-ID: <47B01D47.10006@vlnb.net>
References: <462600.51623.qm@web31810.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-relay-02.mailcluster.net ([77.221.130.214]:60013 "EHLO
	mail-relay-02.mailcluster.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751567AbYBKKDG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Feb 2008 05:03:06 -0500
In-Reply-To: <462600.51623.qm@web31810.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ltuikov@yahoo.com
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, scst-devel@lists.sourceforge.net, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Luben Tuikov wrote:
>>>Is there an open iSCSI Target implementation which
>>
>>does NOT
>>
>>>issue commands to sub-target devices via the SCSI
>>
>>mid-layer, but
>>
>>>bypasses it completely?
>>
>>What do you mean? To call directly low level backstorage
>>SCSI drivers 
>>queuecommand() routine? What are advantages of it?
> 
> Yes, that's what I meant.  Just curious.

What's advantage of it?

> Thanks,
>    Luben
