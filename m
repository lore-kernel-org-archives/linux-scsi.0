From: "Quat Le" <Quat.Le@dothill.com>
Subject: ATA Pass-Through support
Date: Wed, 1 Mar 2006 09:08:24 -0800
Message-ID: <DF9C50EF9E8CDA45A06FE8735C68F85E568F0D@earthex2.power.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 17.129.dothill.com ([155.254.129.17]:42641 "EHLO
	earthex1.dothill.com") by vger.kernel.org with ESMTP
	id S932374AbWCARI1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Mar 2006 12:08:27 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Sorry if this is not the right place to ask this question.

I wrote some application code to send ATA Pass-Through SCSI commands via
SG_IO ioctl to SATA drives connected to a LSI Logic SAS HBA. What I got
was ILLEGAL REQUEST (INVALID COMAND OPERATION CODE) for both SCSI
OPCODE's A1H and 85H. I tried some other SCSI commands and saw that they
were translated to ATA commands correctly. I am running Linux kernel
2.6.15 and am under the impression that it supports ATA Pass-Through.

Thanks,
Quat
