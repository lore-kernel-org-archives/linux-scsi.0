From: Meelis Roos <mroos@linux.ee>
Subject: EISA 53c825 - where to start?
Date: Tue, 16 Nov 2004 11:12:20 +0200 (EET)
Message-ID: <Pine.SOC.4.61.0411161109430.12745@math.ut.ee>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from math.ut.ee ([193.40.5.125]:1978 "EHLO math.ut.ee")
	by vger.kernel.org with ESMTP id S261950AbUKPJMW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Nov 2004 04:12:22 -0500
Received: from math.ut.ee (localhost [IPv6:::1])
	by math.ut.ee (8.12.8+Sun/8.12.8/math-1.2) with ESMTP id iAG9CLbE014795
	for <linux-scsi@vger.kernel.org>; Tue, 16 Nov 2004 11:12:21 +0200 (EET)
Received: from localhost (mroos@localhost)
	by math.ut.ee (8.12.8+Sun/8.12.2/Submit) with ESMTP id iAG9CKGP014773
	for <linux-scsi@vger.kernel.org>; Tue, 16 Nov 2004 11:12:20 +0200 (EET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI list <linux-scsi@vger.kernel.org>

Hi,

I have a Compaq Proliant 4500 with onboard EISA-connected NCR 53c825 
SCSI adapter. There is no EISA-aware version for this chip in Linux 
AFAIK so I want to make one. EISA API is there, also several NCR/Sym/LSI 
SCSI drivers. Which driver is the best to base the eisa work on? And 
where should I start? :)

-- 
Meelis Roos (mroos@linux.ee)
