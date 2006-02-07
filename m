From: Brian King <brking@us.ibm.com>
Subject: Re: [PATCH] Recognize missing LUNs for non-standard devices
Date: Tue, 07 Feb 2006 09:40:00 -0600
Message-ID: <43E8BF50.70800@us.ibm.com>
References: <Pine.LNX.4.44L0.0602071027340.5164-100000@iolanthe.rowland.org>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:53452 "EHLO e6.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1751121AbWBGPkH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Feb 2006 10:40:07 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e6.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id k17Fe5Tt024891
	for <linux-scsi@vger.kernel.org>; Tue, 7 Feb 2006 10:40:05 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VERS6.8) with ESMTP id k17Fe29P206458
	for <linux-scsi@vger.kernel.org>; Tue, 7 Feb 2006 10:40:04 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11/8.13.3) with ESMTP id k17Fe2RN019857
	for <linux-scsi@vger.kernel.org>; Tue, 7 Feb 2006 10:40:02 -0500
In-Reply-To: <Pine.LNX.4.44L0.0602071027340.5164-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI development list <linux-scsi@vger.kernel.org>

Alan Stern wrote:
> On Tue, 7 Feb 2006, Brian King wrote:
> 
>>> I was afraid that might happen.  Okay, forget the patch.
>>>
>>> How come you didn't mention the ipr driver before when I first raised the 
>>> possibility of making this change?
>> Sorry about that... I wanted to verify on my end that the scsi level getting
>> returned was 0 before doing so. Your repost was a reminder...
> 
> Maybe there's a way around this.  Would it be okay to add a flag to the 
> target structure, to indicate that PDT = 0x1f should be interpreted as "No 
> LUN present"?

Works for me.

-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
