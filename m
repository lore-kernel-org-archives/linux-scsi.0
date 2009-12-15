From: Prashant Bhole <prashantsmailcenter@gmail.com>
Subject: query regarding command conversion
Date: Tue, 15 Dec 2009 17:26:08 +0530
Message-ID: <9ff69a5d0912150356w583bfdefs1a9046842609cfba@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.27]:29085 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753550AbZLOL4J (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Dec 2009 06:56:09 -0500
Received: by qw-out-2122.google.com with SMTP id 3so866170qwe.37
        for <linux-scsi@vger.kernel.org>; Tue, 15 Dec 2009 03:56:08 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,
I have a SATA disk which is represented by node /dev/sdb.
I opened that device using open_blk_excl() to perform IO from a kernel module.
IO request is submitted using generic_make_request() which is in terms
of struct bio.
As per my knowledge LLDs do not deal with struct bio.

My question is, where does the struct bio to struct scatterlist
conversion takes place
before SCSI layer calls hostt->queuecommand()?

Thanks,
-- 
~p~r~a~s~h~a~n~t~
