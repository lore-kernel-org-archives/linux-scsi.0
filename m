From: Brian King <brking@us.ibm.com>
Subject: Re: Transport affected timeouts...
Date: Thu, 22 Apr 2004 16:45:26 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40883CF6.8050808@us.ibm.com>
References: <3356669BBE90C448AD4645C843E2BF2802C016E3@xbl.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.103]:5375 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S264714AbUDVVpm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Apr 2004 17:45:42 -0400
List-Id: linux-scsi@vger.kernel.org
To: "Smart, James" <James.Smart@Emulex.com>
Cc: 'James Bottomley' <James.Bottomley@SteelEye.com>, Linux SCSI Reflector <linux-scsi@vger.kernel.org>

Smart, James wrote:
> 
>>I know the way solaris does this is to have a global variable that
>>allows you to raise the timeout.  If we simply exposed 
>>Brian's proposed
>>parameter in sysfs, so you could change it from user space, would that
>>be sufficient?
> 
> 
> 
> Yes.

I'll respin the patch.


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

