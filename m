From: Bryan Henderson <hbryan@us.ibm.com>
Subject: Re: Why is the kernel complaining about large SCSI LUNs
Date: Fri, 7 Jan 2005 17:57:04 -0800
Message-ID: <OF73B1AC23.7FA0C87C-ON88256F83.000A7C52-88256F83.000AAD20@us.ibm.com>
References: <1105141041.4151.32.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:34279 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261767AbVAHB4V (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Jan 2005 20:56:21 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e5.ny.us.ibm.com (8.12.10/8.12.10) with ESMTP id j081uLGb023838
	for <linux-scsi@vger.kernel.org>; Fri, 7 Jan 2005 20:56:21 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j081uLaI256392
	for <linux-scsi@vger.kernel.org>; Fri, 7 Jan 2005 20:56:21 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11/8.12.11) with ESMTP id j081uKWR005984
	for <linux-scsi@vger.kernel.org>; Fri, 7 Jan 2005 20:56:20 -0500
In-Reply-To: <1105141041.4151.32.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Maurice Volaski <mvolaski@aecom.yu.edu>

>It currently looks like the REPORT_LUNS command
>didn't return any data in even though returned status was GOOD, so it's
>probably a fault either of the device or the controller.

Isn't it also a bug in Linux?  If the device didn't return data, the error 
message should be "REPORT_LUNS is broken -- it didn't return any data" 
instead of "LUN is too big" followed by contents of storage that was never 
set to anything by anybody, right?

