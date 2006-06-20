From: Arild Jensen <ml-linux-scsi@counter-attack.com>
Subject: Always seeing 36 LUNs from qla2xxx HBA
Date: Tue, 20 Jun 2006 16:59:40 -0700
Message-ID: <20060620235940.GC10957@wiggle.dreamhost.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smarty.dreamhost.com ([66.33.216.24]:59287 "EHLO
	smarty.dreamhost.com") by vger.kernel.org with ESMTP
	id S932164AbWFTX7l (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jun 2006 19:59:41 -0400
Received: from wiggle.dreamhost.com (wiggle.dreamhost.com [66.33.197.206])
	by smarty.dreamhost.com (Postfix) with ESMTP id 6EE20EE221
	for <linux-scsi@vger.kernel.org>; Tue, 20 Jun 2006 16:59:40 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I have an interesting problem on my Linux box:

Setup:
IBM x445 server
2 x QLA2340 fiber HBAs
Brocade Director 12000 switch
Hitachi HDS 9960 RAID array
SLES 9 OS, kernel-bigsmp-2.6.5-7.201

Problem:
The qla2xxx driver *always* reports 36 SCSI2 LUNs, regardless of what I
configure on the RAID array. It should report 17 SCSI3 LUNs. I am certain
the problem is with/close to the OS because:

	* I have another x445 box running the same OS and kernel version
	  and it has no problems.
	* I have swapped the HBAs with another box and the problem
	  stayed in the box. The LUNs I have assigned to this box showed
	  up correctly in the other server during the swap.
	* I've even swapped the M/B (though not the PCI backplane, which
	  is separate) and moved the HBAs around in the PCI slots.

I've worked on this for about six weeks now and I'm running out of
ideas. Any help debugging this is appreciated.

Thanks!
-- 
Arild Jensen
