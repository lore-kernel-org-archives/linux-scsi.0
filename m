From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: zero block writes
Date: 20 Oct 2003 11:55:57 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1066672557.2271.7.camel@patehci2>
References: <1066160907.3501.9.camel@patehci2> <3F8C79F0.6070105@torque.net>
	 <1066173526.3037.51.camel@patehci2>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:2944 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S262692AbTJTR4F
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Oct 2003 13:56:05 -0400
In-Reply-To: <1066173526.3037.51.camel@patehci2>
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

> > From: dougg@torque.net ...
> >
> > Also when I tested this on scsi_debug, it complained
> > about getting a NULL data buffer pointer.
> 
> CONFIG_SCSI_DEBUG option of .config ...

I continue to see "scsi_debug" here might mean CONFIG_SCSI_DEBUG.  But
in review later also I noticed the keyword "scsi_debug" appears nearby
in Google in the context:

Linux too has virtual SCSI devices.

For Linux 2.4:
http://www.torque.net/sg/sdebug.html

For Linux 2.6 since 2003 Oct 8:
http://www.torque.net/sg/sdebug26.html

Whether it is the virtual scsi_debug device or the CONFIG_SCSI_DEBUG
that complains of NULL data buffer pointers for us, I do not yet know.

Pat LaVarre


