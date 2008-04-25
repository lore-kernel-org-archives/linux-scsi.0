From: Chandru <chandru@in.ibm.com>
Subject: diskdump and aacraid
Date: Fri, 25 Apr 2008 12:20:43 +0530
Message-ID: <48117F43.70000@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:55606 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755626AbYDYGxU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Apr 2008 02:53:20 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp03.au.ibm.com (8.13.1/8.13.1) with ESMTP id m3P6qUwt010646
	for <linux-scsi@vger.kernel.org>; Fri, 25 Apr 2008 16:52:30 +1000
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m3P6oekw241806
	for <linux-scsi@vger.kernel.org>; Fri, 25 Apr 2008 16:50:40 +1000
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m3P6okwc012283
	for <linux-scsi@vger.kernel.org>; Fri, 25 Apr 2008 16:50:46 +1000
Received: from [9.124.31.71] ([9.124.31.71])
	by d23av01.au.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id m3P6oisA012256
	for <linux-scsi@vger.kernel.org>; Fri, 25 Apr 2008 16:50:45 +1000
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I am using diskdump feature of Redhat enterprise linux. The system has 
Adaptec AAC-RAID (Rocket) (rev 02) . 'modinfo aacraid'  gives version as 
1.1-5[2441].  During  kernel crashes, diskdump starts to dump the memory 
on to the disk but however fails after sometime with another 'unable to 
handle null pointer dereference' error.  Before starting the dump 
process a message like the following appears on the console

start dumping to sda5
<3>aacraid: Host adapter reset request. SCSI hang ?


Wanted to check if a message like above can cause the adapter to reset 
when the dump is still in progress ?.

Thanks,
Chandru
