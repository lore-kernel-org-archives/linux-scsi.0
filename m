From: Lars =?UTF-8?B?VMOkdWJlcg==?= <taeuber@bbaw.de>
Subject: Re: mptsas and ioc0: ERRORs
Date: Mon, 14 Apr 2008 09:22:30 +0200
Message-ID: <20080414092230.91fcd030.taeuber@bbaw.de>
References: <20080407104940.5c7c89d1.taeuber@bbaw.de>
	<0631C836DBF79F42B5A60C8C8D4E8229F79FF7@NAMAIL2.ad.lsil.com>
	<20080408093858.5ea6f2ed.taeuber@bbaw.de>
	<200804082010.44090.bs@q-leap.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.bbaw.de ([194.95.188.6]:54764 "EHLO mail.bbaw.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751780AbYDNHV5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Apr 2008 03:21:57 -0400
Received: from mailhub.bbaw.de (unknown [192.168.4.1])
	by mail.bbaw.de (Postfix) with ESMTP id A50314A8073
	for <linux-scsi@vger.kernel.org>; Mon, 14 Apr 2008 09:21:55 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by mailhub.bbaw.de (Postfix) with ESMTP id 4EF5E93767
	for <linux-scsi@vger.kernel.org>; Mon, 14 Apr 2008 09:21:55 +0200 (CEST)
Received: from taeuber.bbaw.de (taeuber.bbaw.de [192.168.1.148])
	by mailhub.bbaw.de (Postfix) with SMTP id 37E839375C
	for <linux-scsi@vger.kernel.org>; Mon, 14 Apr 2008 09:21:55 +0200 (CEST)
In-Reply-To: <200804082010.44090.bs@q-leap.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi there!

Just for completeness:
It seems my problem was caused by a very old firmware on the recently bought new HBA.
It's a bit inconsistent but the firmware is told in hex under proc:

monosan:~ # cat /proc/mpt/summary 
ioc0: LSISAS1068 B1, FwRev=01180100h, Ports=1, MaxQ=366, IRQ=4347

and in dec on the website:
SAS3801X  	FW:1.24.01 BIOS:6.20.00  	10-DEC-07

The problem hasn't occured since 4 days now. I hope the best.

Regards
Lars
