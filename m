From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: PE1800 S-ATA RAID CERC6 with RHEL 3 / 4 ???
Date: Mon, 11 Jul 2005 08:02:47 -0400
Message-ID: <60807403EABEB443939A5A7AA8A7458B01642F00@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:45969 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261647AbVGKMEI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Jul 2005 08:04:08 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kit Gerrits <kitgerrits@gmail.com>, linux-poweredge@dell.com
Cc: linux-scsi@vger.kernel.org

One of the problems with this class (2.4.* based 64 bit) is the Software
IOMMU. You may have to boot with 'swiotlb=12288' in order to free enough
mapping resources for the card.

RHEL4/CentOS4 does not have this problem.

Sincerely -- Mark Salyzyn

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Kit Gerrits
Sent: Monday, July 11, 2005 3:20 AM
To: linux-poweredge@dell.com
Cc: linux-scsi@vger.kernel.org
Subject: PE1800 S-ATA RAID CERC6 with RHEL 3 / 4 ???

Hello all,

Are there any special considerations when using RedHat Enterprise Linux
(or
CentOS) 3 /4 on a PowerEdge 1800 with S-ATA RAID.

I am moving the system from a PE 1600 with PERC2/Si, probably starting
with
a fresh install, moving config and date later on.

Thanks in advance,

Kit
