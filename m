From: "Quat Le" <Quat.Le@dothill.com>
Subject: ATA Pass-Through support for libata
Date: Tue, 28 Feb 2006 08:57:53 -0800
Message-ID: <DF9C50EF9E8CDA45A06FE8735C68F85E4AAB2A@earthex2.power.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 17.129.dothill.com ([155.254.129.17]:51137 "EHLO
	earthex1.dothill.com") by vger.kernel.org with ESMTP
	id S1751822AbWB1Q54 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Feb 2006 11:57:56 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I understand that 2.6.15 has the ATA Pass-Through support in libata.
However, I'm getting back ILLEGAL REQUEST (INVALID COMAND OPERATION
CODE) for both SCSI OPCODE's A1H and 85H.

Is it because I don't have the right patch?  How do I check to see if my
kernel has this patch?  Thanks in advance for you help.


Best regards,
Quat Le
