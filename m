From: Brian King <brking@us.ibm.com>
Subject: Re: System freeze when accessing st.ko and /dev/st0
Date: Fri, 06 Feb 2004 14:54:53 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4023FF1D.3090605@us.ibm.com>
References: <20040206194225.GA27385@mail.fortuitous.com> <4023F466.7000100@us.ibm.com> <20040206202903.GB1488@beaverton.ibm.com> <4023FD5E.8060604@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.132]:33221 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S265583AbUBFUy6
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Feb 2004 15:54:58 -0500
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: Mike Anderson <andmike@us.ibm.com>, pac@fortuitous.com, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@SteelEye.com>, Kai.Makisara@kolumbus.fi, dgilbert@interlog.com

Brian King wrote:
> Mike Anderson wrote:
> 
>> Brian King [brking@us.ibm.com] wrote:
>>
>>> I have been debugging this same problem in sg today. It appears as if
>>> kobj_unmap is never getting called when a device is deleted. When I
>>> added a call to kobj_unmap, the problem went away. I'm currently working
>>> on a patch for this.
>>>
>>> -Brian
>>
>>
>>
>> Are you indicating that we need a direct call to kobj_unmap along with
>> the call to cdev_unmap?

Sorry. I just realized this was already reported and fixed. Just hasn't made
it into the mainline...


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

