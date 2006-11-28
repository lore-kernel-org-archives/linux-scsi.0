From: Mark Haverkamp <markh@osdl.org>
Subject: Re: aic94xx panic on module load
Date: Tue, 28 Nov 2006 15:17:42 -0800
Message-ID: <1164755862.21827.28.camel@markh3.pdx.osdl.net>
References: <1164734233.21827.8.camel@markh3.pdx.osdl.net>
	 <456C83A2.8020507@torque.net>
	 <1164750379.21827.26.camel@markh3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:63939 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1757862AbWK1XVK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Nov 2006 18:21:10 -0500
In-Reply-To: <1164750379.21827.26.camel@markh3.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi <linux-scsi@vger.kernel.org>, djwong@us.ibm.com

On Tue, 2006-11-28 at 13:46 -0800, Mark Haverkamp wrote:
> On Tue, 2006-11-28 at 13:44 -0500, Douglas Gilbert wrote:
> 
> [ ... ]
> 

I don't know if this helps, but I found the verbose option.  Here is a
little debug output.


./smp_discover -vvvvvvvvv  -p 12 -s 0x500508b300a27a2f /dev/mptctl
    Discover request: 40 10 00 02 00 00 00 00 00 0c 00 00 00 00 00 00
send_req_mpt: subvalue=0  SAS address=0x500508b300a27a2f
    mptctl two scatter gather list interface
IOCStatus=0x1
IOCStatus=0x1 IOCLogInfo=0xA27A2F SASStatus=0x0
smp_send_req failed, res=-1


> 
> > 
-- 
Mark Haverkamp <markh@osdl.org>

