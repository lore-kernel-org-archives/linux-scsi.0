From: "Frank Borich" <Frank_Borich@us.xyratex.com>
Subject: RE: Scsi midlayer question
Date: Fri, 16 Jul 2004 11:41:48 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <47F3C2BE74738E4683574107469DFA204CC501@XYUSEX01.xyus.xyratex.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xyratexus11.xyratex.com ([65.203.33.11]:8751 "EHLO
	XYUSEX01.xyus.xyratex.com") by vger.kernel.org with ESMTP
	id S266549AbUGPSmM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Jul 2004 14:42:12 -0400
Content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Bryan Henderson <hbryan@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

I am generating this transfer using a c program using read/write system
calls with the open flag
O_WRONLY to sd driver.

Frank Borich
------------------------------------------------------------------
Xyratex Inc.
Systems Engineer
Direct 630 654 6089
Fax 630 325 2513
e-mail frank_borich@us.xyratex.com
 
 

>>-----Original Message-----
>>From: Bryan Henderson [mailto:hbryan@us.ibm.com] 
>>Sent: Friday, July 16, 2004 1:25 PM
>>To: Frank Borich
>>Cc: linux-scsi@vger.kernel.org
>>Subject: Re: Scsi midlayer question
>>
>>>I can see from a fibre channel trace that my 1 MB I/O transfers are 
>>>getting cut up into little chunks.
>>
>>What is "my 1 MB I/O transfer"?  How are you generating or 
>>seeing this transfer?  Sg device?
>>
>>I ask because sometimes when I hear this question, the 
>>transfer is a transfer to the page cache, so it has only a 
>>loose association with transfers on the fibre channel.
>>
>>--
>>Bryan Henderson                          IBM Almaden Research Center
>>San Jose CA                              Filesystems
>>
>>
