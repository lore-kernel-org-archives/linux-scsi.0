From: Andi Kleen <ak@suse.de>
Subject: Queue full messages on mpt fusion
Date: Sat, 13 Mar 2004 03:31:45 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040313023145.GE4638@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:63725 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S263027AbUCMCbq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Mar 2004 21:31:46 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Emoore@lsil.com
Cc: linux-scsi@vger.kernel.org


Hi Eric,

Just for your info: I did some stress tests with AIM7 on a 4way Opteron
with MPT-Fusion and a single SCSI disk. This resulted in lots of

mptscsih: ioc1: WARNING - Device (0:0:0) reported QUEUE_FULL!

messages. They didn't seem to have an averse effect. Maybe it 
would make sense to comment out this warning because I suppose
it can happen at normal run time?

-Andi
