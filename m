From: Russ Garrett <russ@garrett.co.uk>
Subject: Megaraid on AMD64
Date: Wed, 01 Sep 2004 16:44:26 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4135EE5A.7090304@garrett.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mta05-svc.ntlworld.com ([62.253.162.45]:13664 "EHLO
	mta05-svc.ntlworld.com") by vger.kernel.org with ESMTP
	id S267199AbUIAPmK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Sep 2004 11:42:10 -0400
Received: from [192.168.99.15] ([81.99.187.205]) by mta05-svc.ntlworld.com
          (InterMail vM.4.01.03.37 201-229-121-137-20020806) with ESMTP
          id <20040901153937.TEEJ11492.mta05-svc.ntlworld.com@[192.168.99.15]>
          for <linux-scsi@vger.kernel.org>; Wed, 1 Sep 2004 16:39:37 +0100
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

We have a Megaraid 320-1 in a dual Opteron server, but we were wondering 
if there's any way to manage the array from inside the OS. 
Megamgr/dellmgr don't appear to work on 64-bit at all. We're currently 
using the driver version 2.00.3, since the new unified drivers don't 
even seem to have an equivalent to the /proc interface to see the 
array's status. Since the server is 800 miles away, it's a bit of a pain 
rebooting into the BIOS in order to check anything.

On a slightly different (and off-topic) note, would anyone like to take 
a guess at how a drive failure managed to corrupt our RAID 0+1 volume? 
Would it be a driver issue, or just the drive corrupting the data 
without noticing?

Thanks in advance,

Russ Garrett
russ@last.fm
