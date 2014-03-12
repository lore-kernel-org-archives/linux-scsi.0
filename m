From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: blk_iopoll_enabled
Date: Wed, 12 Mar 2014 19:35:07 +0200
Message-ID: <53209ACB.2080708@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:36197 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755894AbaCLRfN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Mar 2014 13:35:13 -0400
Received: by mail-we0-f179.google.com with SMTP id x48so11386107wes.24
        for <linux-scsi@vger.kernel.org>; Wed, 12 Mar 2014 10:35:11 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Bart Van Assche <bvanassche@acm.org>, Or Gerlitz <ogerlitz@mellanox.com>, Oren Duer <oren@mellanox.com>, linux-scsi <linux-scsi@vger.kernel.org>

Hey Jens,

So I'm looking at blk_iopoll for iSER & SRP and I have one gap I would 
like to get your input on.

In blk-iopoll.c I see:
int blk_iopoll_enabled = 1;
EXPORT_SYMBOL(blk_iopoll_enabled);

This is set to 1 and exported for everyone to condition and *modify* it.
The documentation says the user must check this when using blk_iopoll.

My question is why? it should always be true shouldn't it?
Moreover, isn't it better to protect it using a get() function of it?
can't someone set it to 0 and shutdown the lights on everyone else?

Thanks,

Sagi.
