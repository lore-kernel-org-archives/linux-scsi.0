From: "Jeffrey W. Baker" <jwb@gghcwest.com>
Subject: rescan-scsi-bus.sh no longer unsafe with aic79xx
Date: 05 Jun 2003 11:01:48 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1054836108.22202.10.camel@heat>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [65.198.37.67] ([65.198.37.67]:31712 "EHLO gghcwest.com")
	by vger.kernel.org with ESMTP id S264816AbTFERsR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Jun 2003 13:48:17 -0400
Received: from pc105.gghcwest.com (pc105.gghcwest.com [192.168.168.105])
	by gghcwest.com (8.12.9/8.12.9) with ESMTP id h55I1lR8030510
	for <linux-scsi@vger.kernel.org>; Thu, 5 Jun 2003 11:01:47 -0700
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On 2.4.21-rc3/amd64 with previous aic79xx patches, use of
rescan-scsi-bus.sh had a tendency to hose the entire machine.  If there
was a new device, aic79xx emitted a console message that it could not
allocate the new device.  After that all I/O to the device failed,  and
the rescan-scsi-bus.sh process was in the D state forever.

In the latest aic79xx, this no longer happens.  rescan-scsi-bus.sh works
fine.

Cheers,
jwb


