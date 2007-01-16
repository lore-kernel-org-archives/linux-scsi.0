From: Aboo Valappil <aboo@aboo.org>
Subject: Linux Virtual SCSI HBAs and Virtual disks
Date: Tue, 16 Jan 2007 21:22:29 +1100
Message-ID: <45ACA765.3030701@aboo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ppp245-155.static.internode.on.net ([59.167.245.155]:41024 "EHLO
	goobu.aboo.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751043AbXAPL7U (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Jan 2007 06:59:20 -0500
Received: from [192.168.1.65] ([192.168.1.65])
	by goobu.aboo.org (8.13.1/8.13.1) with ESMTP id l0G9DjJw007970
	for <linux-scsi@vger.kernel.org>; Tue, 16 Jan 2007 20:13:45 +1100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi All,

I have tried this before but I guess I was unsuccessful in presenting it 
properly in the mailing list. I think it is really useful especially for 
prototyping and also for people who wants to develop their own scsi 
targets and transports.
There are few people told me about the SCSI target and initiator 
implementation of XEN. But I do not think it is this simple and might 
take a while to port it to normal linux kernel.  At the moment, there is 
nothing like this available in a simplest form.

Please visit this site http://vscsihba.aboo.org. I put a complete 
description of the project and the source code. I appreciate if you 
could go through it and put your thoughts....  This is my final attempt 
in this mailing list before I throw away whole of my work.

Thanks

Aboo

