From: Mark Haverkamp <markh@osdl.org>
Subject: RE: Kernel OOPS with aacraid driver
Date: Fri, 22 Apr 2005 08:42:09 -0700
Message-ID: <1114184529.18887.3.camel@markh1.pdx.osdl.net>
References: <df35dfeb050422000856c882d6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fire.osdl.org ([65.172.181.4]:52412 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S261880AbVDVPmP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Apr 2005 11:42:15 -0400
In-Reply-To: <df35dfeb050422000856c882d6@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Yum Rayan <yum.rayan@gmail.com>
Cc: Klaus.Steinberger@physik.uni-muenchen.de, linux-scsi <linux-scsi@vger.kernel.org>, "Randy.Dunlap" <rddunlap@osdl.org>

On Fri, 2005-04-22 at 00:08 -0700, Yum Rayan wrote:
> > > BTW, this says that this is the second oops:  "[#2]".
> > > What was the first one?
> > Apr 21 10:53:27 www adaptec-smbe: aiomgrd startup succeeded
> > Apr 21 10:53:27 www kernel: Unable to handle kernel NULL 
> > pointer dereference 
> > at virtual address 00000034
> 
> Seems to me like someone is issuing IOCTL's against devices that do
> not exist. Does this patch against linux-2.6.12-rc3 make sense and
> applicable to you?
> 
A fix for this was submitted to the list last week.

Mark.


-- 
Mark Haverkamp <markh@osdl.org>

