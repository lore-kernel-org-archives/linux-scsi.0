From: Sakthivel Saravanan Kamal Raju <sakthivel.sk@hcl.com>
Subject: RE: RE [PATCH] [SCSI] pm8001: Added support for 8008, 8009, 8018,
 8019 controllers
Date: Thu, 17 May 2012 12:50:48 +0530
Message-ID: <FEB196E0808DE0408A6E24DF8A0BB09327358927E8@CHN-HCLT-EVS09.HCLT.CORP.HCL.IN>
References: <FEB196E0808DE0408A6E24DF8A0BB09327358926B5@CHN-HCLT-EVS09.HCLT.CORP.HCL.IN>
 <9918F2695F484B20B1FE6B26F0ACC207@usish.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gws07.hcl.com ([192.8.186.130]:17612 "EHLO GWS07.hcl.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760760Ab2EQHU6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 May 2012 03:20:58 -0400
In-Reply-To: <9918F2695F484B20B1FE6B26F0ACC207@usish.com.cn>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jack Wang <jack_wang@usish.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jejb@kernel.org" <jejb@kernel.org>
Cc: "lindar_liu@usish.com" <lindar_liu@usish.com>, "Anand Kumar S - ERS, HCL Tech" <sanandkumar@hcl.com>

Hi Jack,

Thanks for the inputs. Will update the patch accordingly and send it.

Thanks
Sakthivel K

-----Original Message-----
From: Jack Wang [mailto:jack_wang@usish.com]
Sent: Thursday, May 17, 2012 7:45 AM
To: Sakthivel Saravanan Kamal Raju; linux-scsi@vger.kernel.org; jejb@kernel.org
Cc: lindar_liu@usish.com; Anand Kumar S - ERS, HCL Tech
Subject: RE [PATCH] [SCSI] pm8001: Added support for 8008, 8009, 8018, 8019 controllers


Hi Sakthivel K,

Please generate patch against for next branch in URL:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git

In your new file most function are same with pm8001 please try to reuse
that, not just only change function name or structure name.

Please separate this big patch into different patches,that will more
reviewable.

Thanks

Jack




::DISCLAIMER::
-----------------------------------------------------------------------------------------------------------------------

The contents of this e-mail and any attachment(s) are confidential and intended for the named recipient(s) only.
E-mail transmission is not guaranteed to be secure or error-free as information could be intercepted, corrupted,
lost, destroyed, arrive late or incomplete, or may contain viruses in transmission. The e mail and its contents
(with or without referred errors) shall therefore not attach any liability on the originator or HCL or its affiliates.
Views or opinions, if any, presented in this email are solely those of the author and may not necessarily reflect the
views or opinions of HCL or its affiliates. Any form of reproduction, dissemination, copying, disclosure, modification,
distribution and / or publication of this message without the prior written consent of authorized representative of
HCL is strictly prohibited. If you have received this email in error please delete it and notify the sender immediately.
Before opening any email and/or attachments, please check them for viruses and other defects.

-----------------------------------------------------------------------------------------------------------------------
