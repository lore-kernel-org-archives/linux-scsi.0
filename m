From: "Rajat  Jain, Noida" <rajatj@noida.hcltech.com>
Subject: How to find which (physical) SCSI HBA corresponds to which host n
	umber?
Date: Thu, 31 Mar 2005 14:32:31 +0530
Message-ID: <267988DEACEC5A4D86D5FCD780313FBB065448B3@exch-03.noida.hcltech.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ngate.noida.hcltech.com ([202.54.110.230]:48080 "EHLO
	ngate.noida.hcltech.com") by vger.kernel.org with ESMTP
	id S261202AbVCaJC4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Mar 2005 04:02:56 -0500
Received: from noida.hcltech.com (exch-01.noida.hcltech.com [204.160.254.79] (may be forged))
	by ngate.noida.hcltech.com (8.12.5/8.12.5) with ESMTP id j2V96TrU015997
	for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2005 14:36:56 +0530
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

2
Hi List,

I would appreciate if some one can help me out on these.

1) Suppose my machine has two similar SCSI HBAs. And my Linux box shows them
to me as Hosts 0 and 1 respectively. When I open the chassis, is a there a
way to figure out that physically which of the HBAs I am seeing correspond
to hosts 0 and 1 respectively? The HBAs are similar in every sense (Model /
Make etc). 

2) When I boot up the machine, is it fixed that the same HBA will get host
number 0 every time, or does it depend on some thing?

3) I want to add a new SCSI device at run time. I know when I'll have to use
"scsi add-single-device" command, but I have to supply Host number, channel,
ID and lun to it. I know that ID is set on the device it self, and hence
I'll be knowing it. But how do I know the host no of the HBA that I've added
the device to. Is it just trial and error?

TIA,

Rajat Jain


Disclaimer: 

This message and any attachment(s) contained here are information that is
confidential,proprietary to HCL Technologies and its customers, privileged
or otherwise protected by law.The information is solely intended for the
individual or the entity it is addressed to. If you are not the intended
recipient of this message, you are not authorized to read, forward,
print,retain, copy or disseminate this message or any part of it. If you
have received this e-mail in error, please notify the sender immediately by
return e-mail and delete it from your computer.


