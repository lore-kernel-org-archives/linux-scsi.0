From: Douglas Gilbert <dougg@torque.net>
Subject: Re: usb storage traces
Date: Fri, 05 Dec 2003 14:31:25 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3FD00A1D.2070200@torque.net>
References: <Pine.LNX.4.44L0.0312041329450.994-100000@ida.rowland.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:54788 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S262327AbTLEEbu
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Dec 2003 23:31:50 -0500
In-Reply-To: <Pine.LNX.4.44L0.0312041329450.994-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

Alan Stern wrote:

<snip/>

> Does anybody know what command x23 

READ FORMAT CAPACITIES (found in MMC-3 and MMC-4)

> and mode page x1c do?  Although 
> nominally vendor-specific, 

Vendor specific mode pages start at 0x20 so mode
page 0x1c (Informational Exceptions) is not vendor
specific.

<snip/>

Doug Gilbert

