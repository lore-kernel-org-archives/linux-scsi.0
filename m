From: Stephen Cameron <smcameron@yahoo.com>
Subject: Re: App correlating PCI info with SCSI host number
Date: Thu, 27 Jan 2005 12:06:11 -0800 (PST)
Message-ID: <20050127200611.15414.qmail@web12305.mail.yahoo.com>
References: <20050127171438.GC10491@lists.us.dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web12305.mail.yahoo.com ([216.136.173.103]:56479 "HELO
	web12305.mail.yahoo.com") by vger.kernel.org with SMTP
	id S261160AbVA0UGM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Jan 2005 15:06:12 -0500
In-Reply-To: <20050127171438.GC10491@lists.us.dell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

--- Matt Domsch <Matt_Domsch@dell.com> wrote:
> > Is there any generic way to make the same sort
> > of correlation on 2.4 kernels?
> 
> There's an ioctl() to a disk, SCSI_IOCTL_GET_PCI, so if the controller
> has a disk attached, you can get it.

Ok, thanks, this, in conjunction with SCSI_IOCTL_GET_BUS_NUMBER
seems to do what I want to do.



		
__________________________________ 
Do you Yahoo!? 
The all-new My Yahoo! - What will yours do?
http://my.yahoo.com 
