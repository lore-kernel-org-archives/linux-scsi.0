From: "Rajat  Jain, Noida" <rajatj@noida.hcltech.com>
Subject: How does a SCSI device gets a target ID?
Date: Wed, 9 Mar 2005 21:33:51 +0530
Message-ID: <267988DEACEC5A4D86D5FCD780313FBB0575F03B@exch-03.noida.hcltech.com>
Mime-Version: 1.0
Content-Type: text/plain
Received: from ngate.noida.hcltech.com ([202.54.110.230]:31175 "EHLO
	ngate.noida.hcltech.com") by vger.kernel.org with ESMTP
	id S262045AbVCIQDz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Mar 2005 11:03:55 -0500
Received: from exch-03.noida.hcltech.com ([204.160.254.29])
	by ngate.noida.hcltech.com (8.12.5/8.12.5) with ESMTP id j29G3rCs006082
	for <linux-scsi@vger.kernel.org>; Wed, 9 Mar 2005 21:33:54 +0530
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,
 
I'm new to SCSI. I would appreciate if some one can solve my query:

When a new SCSI device is added to a SCSI channel, how can we find out what
is the target ID of that device? 

1) If a channel supports 8 SCSI devices, then each of the 8 ports will have
a specific Target ID. And any device attached to that port will have that
Target ID.

2) Is it done one the fly? I mean (starting from zero), the SCSI device is
given a target ID that is 1 greater that the last SCSI device's ID. Who
assigns this ID?

TIA,

Rajat
