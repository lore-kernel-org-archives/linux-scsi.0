From: "Abhilash  Sankar - ERS, HCL Tech" <Abhilash.S@hcl.com>
Subject: LIO performance Issue
Date: Wed, 14 Sep 2011 19:30:36 +0530
Message-ID: <EF8AD1CD95CD1E4DBF423FF61CCFC5A9E4E199860C@NDA-HCLT-EVS04.HCLT.CORP.HCL.IN>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gws06.hcl.com ([203.105.185.25]:21772 "EHLO gws06.hcl.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756550Ab1INOBg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Sep 2011 10:01:36 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "nab@linux-iscsi.org" <nab@linux-iscsi.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-iscsi-target-dev@googlegroups.com" <linux-iscsi-target-dev@googlegroups.com>, "Yuvarani C - ERS , HCLTech" <yuvaranic@hcl.com>, "Bagavathy Kumar Mahendran - ERS, HCL Tech" <bagavathykumar.m@hcl.com>


Hi all,

My name is Abhilash, I am new to this community, I am trying to do a performance study of LIO-iSCSI and SCST using robocopy (I/O Tool).
I have successfully ported LIO to my Debian OS. Based on my initial analysis, SCST had shown a better write performance than LIO.

Read performance seems to be almost similar for both the stack. But write performance for file based LIO-iSCSI has degraded more than 50%
while compared to SCST stack in my setup.

I am using LIO 4.0, file based IO and Windows 7 initiator.

It would be much helpful if anyone could give me some suggestion to improve the LIO write performance.

Regards,
Abhilash


::DISCLAIMER::
-----------------------------------------------------------------------------------------------------------------------

The contents of this e-mail and any attachment(s) are confidential and intended for the named recipient(s) only.
It shall not attach any liability on the originator or HCL or its affiliates. Any views or opinions presented in
this email are solely those of the author and may not necessarily reflect the opinions of HCL or its affiliates.
Any form of reproduction, dissemination, copying, disclosure, modification, distribution and / or publication of
this message without the prior written consent of the author of this e-mail is strictly prohibited. If you have
received this email in error please delete it and notify the sender immediately. Before opening any mail and
attachments please check them for viruses and defect.

-----------------------------------------------------------------------------------------------------------------------
