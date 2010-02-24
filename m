From: "Srinivas Naga Venkatasatya Pasagadugula - ERS, HCL Tech"
	<satyasrinivasp@hcl.in>
Subject: RE: [PATCH] MVSAS: hot plug handling and IO issues
Date: Wed, 24 Feb 2010 10:25:36 +0530
Message-ID: <6B62480106F2B34D8404CF2FDAA4D9EF71F64F5D3F@CHN-HCLT-EVS06.HCLT.CORP.HCL.IN-5F7B2F7D-DDFE-5403-A357-D7F9128F284E>
References: <31220.87.210.74.220.1266925266.squirrel@ketsers.dhs.org>
 <4B83C96D.8080605@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gws07.mail.hcl.in ([203.105.186.27]:47421 "EHLO gws07.hcl.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755308Ab0BXEzt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Feb 2010 23:55:49 -0500
In-Reply-To: <4B83C96D.8080605@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Konstantinos Skarlatos <k.skarlatos@gmail.com>, Caspar Smit <c.smit@truebit.nl>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Yes. SMART drives will work this patch. 
Let me know if any issues with SMART and share me `dmesg` output.

--Srini.

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Konstantinos Skarlatos
Sent: Tuesday, February 23, 2010 5:56 PM
To: Caspar Smit; linux-scsi@vger.kernel.org
Subject: Re: [PATCH] MVSAS: hot plug handling and IO issues

Does SMART work with this patch?

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

DISCLAIMER:
-----------------------------------------------------------------------------------------------------------------------

The contents of this e-mail and any attachment(s) are confidential and intended for the named recipient(s) only. 
It shall not attach any liability on the originator or HCL or its affiliates. Any views or opinions presented in 
this email are solely those of the author and may not necessarily reflect the opinions of HCL or its affiliates. 
Any form of reproduction, dissemination, copying, disclosure, modification, distribution and / or publication of 
this message without the prior written consent of the author of this e-mail is strictly prohibited. If you have 
received this email in error please delete it and notify the sender immediately. Before opening any mail and 
attachments please check them for viruses and defect.

-----------------------------------------------------------------------------------------------------------------------

