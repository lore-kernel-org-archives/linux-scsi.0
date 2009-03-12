From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: RE: MSI override changes in mptbase
Date: Thu, 12 Mar 2009 20:29:15 +0530
Message-ID: <0D1E8821739E724A86F4D16902CE275C140E25CBF7@inbmail01.lsi.com>
References: <49B6559C.76E4.0078.0@novell.com>
 <0D1E8821739E724A86F4D16902CE275C140E25C9F9@inbmail01.lsi.com>
 <49B67C2C.76E4.0078.0@novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og107.obsmtp.com ([64.18.2.167]:47858 "EHLO
	exprod7og107.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155AbZCLPAb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Mar 2009 11:00:31 -0400
In-Reply-To: <49B67C2C.76E4.0078.0@novell.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jan Beulich <jbeulich@novell.com>
Cc: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "yinghai@kernel.org" <yinghai@kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Jan,

Best approach is to enable/disable MSI Interrupt on the fly. We are not supporting that feature currently. Something like setting DMA mask through probe code, we should enable/disable MSI interrupt through init code.
Eventually, If MSI enable/disable is not on the fly, it will be always better to keep in default disable in module para of driver.

- Kashyap

-----Original Message-----
From: Jan Beulich [mailto:jbeulich@novell.com] 
Sent: Tuesday, March 10, 2009 7:12 PM
To: Desai, Kashyap
Cc: James.Bottomley@HansenPartnership.com; yinghai@kernel.org; linux-scsi@vger.kernel.org
Subject: RE: MSI override changes in mptbase

>>> "Desai, Kashyap" <Kashyap.Desai@lsi.com> 10.03.09 13:12 >>>
>Default behavior for all 3 buses (FC, SPI, and SAS) with respect to MSI is OFF. It is up to user, whether they want to enable/disable >MSI.

Why is that change in behavior for SAS needed then?

Thanks, Jan


No virus found in this incoming message.
Checked by AVG - www.avg.com 
Version: 8.0.233 / Virus Database: 270.11.9/1989 - Release Date: 03/07/09 18:43:00
