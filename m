From: Clemens Ladisch <clemens@ladisch.de>
Subject: Re: FireWire/SBP2 Target mode
Date: Mon, 06 Feb 2012 15:43:17 +0100
Message-ID: <4F2FE705.3070509@ladisch.de>
References: <4E4BD560.4010806@bootc.net> <4E4D3B88.30003@ladisch.de> <4F29978A.3010707@redhat.com> <20120201224156.0773ebc6@stein> <4F2A55B9.4040005@panasas.com> <4F2A60DC.9030007@ladisch.de> <4F2FD1F4.9050702@bootc.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:40554 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753992Ab2BFOlK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2012 09:41:10 -0500
Received: from compute6.internal (compute6.nyi.mail.srv.osa [10.202.2.46])
	by gateway1.nyi.mail.srv.osa (Postfix) with ESMTP id 5862B20589
	for <linux-scsi@vger.kernel.org>; Mon,  6 Feb 2012 09:41:09 -0500 (EST)
In-Reply-To: <4F2FD1F4.9050702@bootc.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chris Boot <bootc@bootc.net>
Cc: target-devel@vger.kernel.org, linux1394-devel@lists.sourceforge.net, Boaz Harrosh <bharrosh@panasas.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>, Andy Grover <agrover@redhat.com>, linux-scsi@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>

Chris Boot wrote:
> You can pull the code from:
> git://github.com/bootc/Linux-SBP-2-Target.git

The TODO file says:
> * Update Juju so we can get the speed in the fw_address_handler callback

What is the speed needed for?

SBP-2 says:
| The target shall issue data transfer requests with a speed equal to
| that specified by the spd field in the ORB.

SBP-3 says:
| The target shall issue data transfer requests with a speed equal to
| that specified by the controlling spd field, whether in the ORB or in
| a node selector in an associated page table.

> Please note that you can't then disable a unit until all the targets
> are logged-out. For Linux this usually means 'rmmod firewire_sbp2'.

That driver should not, by default, log into targets on its own node.


Regards,
Clemens
