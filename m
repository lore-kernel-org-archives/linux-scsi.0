From: Tameen Khan <tameen@andiamo.com>
Subject: setting maximum queue depth to 255 with sg driver
Date: Fri, 30 May 2003 00:06:07 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4.3.2.7.2.20030529235329.029e0740@andiamo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rtp-core-1.cisco.com ([64.102.124.12]:48572 "EHLO
	rtp-core-1.cisco.com") by vger.kernel.org with ESMTP
	id S263319AbTE3GzG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 May 2003 02:55:06 -0400
Received: from loaner-w2k1.cisco.com (dhcp-171-71-49-113.cisco.com [171.71.49.113])
	by rtp-core-1.cisco.com (8.12.9/8.12.6) with ESMTP id h4U78NFW016635
	for <linux-scsi@vger.kernel.org>; Fri, 30 May 2003 03:08:24 -0400 (EDT)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

goal is to achieve a max queue depth of 255 using qlogic hba qla2342 on a 
linux host (2.4.18)
I am using scsi generic driver to do IO. The queue depth bottleneck is 
SG_MAX_QUEUE as indicated in the documentation.
The SG_MAX_QUEUE value is 16
I've tried one way to bypass this limit (as suggested in 
http://tldp.org/HOWTO/SCSI-Generic-HOWTO/)
That is to do multiple open() to the same device, SG driver should allow 
queueing of 16
commands per device.
This does not work for me and I still see a maximum queue depth of 16.

What could be the reason and what could be a workaround ?
What could be other ways to increase the queue depth beyond 16 ?

