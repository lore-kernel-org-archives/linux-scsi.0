From: Kirill Korotaev <dev@sw.ru>
Subject: MPT fusion driver doesn't work when compiled into kernel
Date: Wed, 14 Jun 2006 11:49:20 +0400
Message-ID: <448FBF80.9090305@sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.233.200]:26526 "EHLO relay.sw.ru")
	by vger.kernel.org with ESMTP id S1751200AbWFNHt1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Jun 2006 03:49:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mpt_linux_developer@lsil.com, Eric.Moore@lsil.com, linux-scsi@vger.kernel.org, Vasily Averin <vvs@sw.ru>, Andrey Mirkin <amirkin@sw.ru>

Hello,

FYI, there is a bug in all(?) 3.x fusion drivers, which prevents it from 
working when all the fusion config options are set to 'y'.

It looks like the driver uses schedule_timeout() for delays inside, 
which can return immediately on the boot stage and thus drives are not 
detected properly.

At least the following verions are affected:
3.03.07
3.02.62.01rh

And according to recent commits it was not fixed since then.

Thanks,
Kirill
