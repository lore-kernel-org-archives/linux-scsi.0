From: Mike Christie <mikenc@us.ibm.com>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.1
Date: Wed, 29 Oct 2003 11:01:50 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3FA00E9E.7000704@us.ibm.com>
References: <20031027153932.A16679@infradead.org>	<018b01c39e1f$e013bab0$a0074d0a@apac.cisco.com>	<20031029134557.A17523@infradead.org> <3F9FF8C7.70909@us.ibm.com> <yqujd6cf51cp.fsf@chaapala-lnx2.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.101]:54270 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261152AbTJ2TCt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Oct 2003 14:02:49 -0500
In-Reply-To: <yqujd6cf51cp.fsf@chaapala-lnx2.cisco.com>
List-Id: linux-scsi@vger.kernel.org
To: Clay Haapala <chaapala@cisco.com>
Cc: linux-scsi@vger.kernel.org


> This may turn out to be a discussion about where this code resides and
> what code is best to (re)use, not if it is needed.  "Early boot" here
> is from PXE -- setting up the iSCSI initiator to reach a target at
> some IP where the rest of the boot (initrd and friends) is.
> 

Oops. I forgot you guys use iNBP.com. I was thinking of pxelinux.

Mike

