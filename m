From: Maurice Volaski <mvolaski@aecom.yu.edu>
Subject: Why is the kernel complaining about large SCSI LUNs
Date: Fri, 7 Jan 2005 11:07:09 -0500
Message-ID: <a06100533be0463eff562@[129.98.90.227]>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii" ; format="flowed"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailgw.aecom.yu.edu ([129.98.1.16]:52972 "EHLO
	mailgw.aecom.yu.edu") by vger.kernel.org with ESMTP id S261477AbVAGQG4
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Jan 2005 11:06:56 -0500
Received: from mailvx.aecom.yu.edu (mailvx.aecom.yu.edu [129.98.1.17])
	by mailgw.aecom.yu.edu (8.12.11/8.12.11) with SMTP id j07G6qsM029066
	for <linux-scsi@vger.kernel.org>; Fri, 7 Jan 2005 11:06:52 -0500
Received: from post.aecom.yu.edu ([129.98.1.126])
 by mailvx.aecom.yu.edu (SAVSMTP 3.1.1.32) with SMTP id M2005010711065121164
 for <linux-scsi@vger.kernel.org>; Fri, 07 Jan 2005 11:06:51 -0500
Received: from [129.98.90.227] (usseinstein.aecom.yu.edu [129.98.90.227])
	by post.aecom.yu.edu (8.11.7p1+Sun/8.11.7) with ESMTP id j07G6p302155
	for <linux-scsi@vger.kernel.org>; Fri, 7 Jan 2005 11:06:51 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I am running kernel 2.6.9 on an Opteron box with an LSI 320 card and 
am seeing the following message repeatedly in dmesg:

scsi: host 1 channel 0 id 0 lun 0x5a5a5a5a5a5a5a5a has a LUN larger 
than currently supported.

Is this just cosmetic or there is a bug somewhere? It appears that 
scsi_scan.c has logic where this message is actually valid, but how 
can that be?
-- 

Maurice Volaski, mvolaski@aecom.yu.edu
Computing Support, Rose F. Kennedy Center
Albert Einstein College of Medicine of Yeshiva University
