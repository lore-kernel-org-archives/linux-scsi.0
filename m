From: Andrew Morton <akpm@osdl.org>
Subject: Fw: variable used before set
Date: Thu, 28 Jul 2005 22:52:17 -0700
Message-ID: <20050728225217.43cae3b7.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:60069 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S262382AbVG2FxT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Jul 2005 01:53:19 -0400
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp.osdl.org (8.12.8/8.12.8) with ESMTP id j6T5rGjA005751
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 28 Jul 2005 22:53:16 -0700
Received: from bix (shell0.pdx.osdl.net [10.9.0.31])
	by shell0.pdx.osdl.net (8.13.1/8.11.6) with SMTP id j6T5rFTa012122
	for <linux-scsi@vger.kernel.org>; Thu, 28 Jul 2005 22:53:16 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


This is surely a bug.   Can someone please suggest how it should
be fixed?

Thanks.

Begin forwarded message:

Date: Tue, 28 Jun 2005 09:14:28 +0000
From: "d binderman" <dcb314@hotmail.com>
To: linux-kernel@vger.kernel.org
Subject: variable used before set


Hello there,

I just tried to compile the Linux Kernel version 2.6.11.12
with the most excellent Intel C compiler. It said

drivers/scsi/pcmcia/aha152x_stub.c(313): remark #592: variable "tmp" is used 
before its value is set
        tmp.device->host = info->host;
        ^

This is clearly broken code, since the field tmp.device has not been
initialised, and so isn't pointing to anything.

Suggest code rework.

_________________________________________________________________
Want to block unwanted pop-ups? Download the free MSN Toolbar now!  
http://toolbar.msn.co.uk/

-
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
