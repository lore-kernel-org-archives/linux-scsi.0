From: Brian King <brking@us.ibm.com>
Subject: Re: Transport affected timeouts...
Date: Thu, 22 Apr 2004 14:09:08 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40881854.1000602@us.ibm.com>
References: <3356669BBE90C448AD4645C843E2BF2802C016E2@xbl.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.106]:23192 "EHLO e6.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S264639AbUDVTJM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Apr 2004 15:09:12 -0400
List-Id: linux-scsi@vger.kernel.org
To: "Smart, James" <James.Smart@Emulex.com>
Cc: 'James Bottomley' <James.Bottomley@SteelEye.com>, Linux SCSI Reflector <linux-scsi@vger.kernel.org>

Smart, James wrote:
> One question though - how does the LLD really know what the timeout should
> be ?  It doesn't identify a target as a raid device does it ? or what raid
> level it's using ?

Yes, the slave_configure routine knows that the device is a RAID array and
sets the rw_timeout value appropriately.


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

