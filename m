From: Brian King <brking@us.ibm.com>
Subject: Re: [PATCH] Hidden scsi devices
Date: Thu, 22 Jan 2004 11:07:22 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4010034A.3040903@us.ibm.com>
References: <OF8847A70B.4AA684AE-ONC1256E23.00571E7C-C1256E23.0058163C@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.104]:10148 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S266274AbUAVRH0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Jan 2004 12:07:26 -0500
Received: from northrelay02.pok.ibm.com (northrelay02.pok.ibm.com [9.56.224.150])
	by e4.ny.us.ibm.com (8.12.10/8.12.2) with ESMTP id i0MH7PvM309350
	for <linux-scsi@vger.kernel.org>; Thu, 22 Jan 2004 12:07:25 -0500
List-Id: linux-scsi@vger.kernel.org
To: Martin Peschke3 <MPESCHKE@de.ibm.com>
Cc: linux-scsi@vger.kernel.org

Martin Peschke3 wrote:
> Brian,
> 
> why should a LLDD need to bother about device characteristics?
> I tend to say that it is completely up to upper layer drivers to
> handle such device specialties.
> How does a LLDD know about that r/w protection feature anyway?

Because the device is reported to the LLDD by the adapter as a
specific device type. The adapter creates a configuration table
describing all attached devices that the LLDD must retrieve. In this
configuration table there are several types of devices:

1. Adapter itself.
2. Generic SCSI devices.
3. Logical disk array devices (VSET)
4. Advanced function devices (devices in RAID arrays).

In my situation the only one who knows about this device characteristic
is the LLDD.


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

