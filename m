From: Douglas Gilbert <dougg@torque.net>
Subject: Re: Support for CDB length > 16
Date: Tue, 18 Nov 2003 19:33:43 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3FB9E777.6020404@torque.net>
References: <OFA910CD2E.7013EC62-ONC2256DE2.002FD991-C2256DE2.00307FFC@il.ibm.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:56080 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S262149AbTKRJfj
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Nov 2003 04:35:39 -0500
In-Reply-To: <OFA910CD2E.7013EC62-ONC2256DE2.002FD991-C2256DE2.00307FFC@il.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Liran Schour <LIRANS@il.ibm.com>
Cc: linux-scsi@vger.kernel.org

Liran Schour wrote:
> 
> I need a support from the Linux SCSI subsystem for CDB length > 16 byte.
> Is it possible to do that without recompiling the kernel with a new
> MAX_COMMAND_SIZE definition. 

It is hard to imagine any other way at the moment (definitely
in lk 2.4 and it is probably a bit late for lk 2.6).

Is there an upper limit on the size of the cdb you are interested in
(e.g. XDWRITE EXTENDED in SBC-2 is 64 bytes)?

How were you planning to pass the cdb (length > 16) to the kernel?

Doug Gilbert


