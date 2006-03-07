From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: RFC: Move SG_GET_SCSI_ID from sg to scsi
Date: Tue, 07 Mar 2006 15:58:22 +0100
Message-ID: <440D9F8E.7050402@s5r6.in-berlin.de>
References: <Pine.LNX.4.58.0603061133070.2997@be1.lrz> <440C8E60.6020005@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:35970 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S1750759AbWCGPA5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Mar 2006 10:00:57 -0500
In-Reply-To: <440C8E60.6020005@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: Bodo Eggert <7eggert@gmx.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Douglas Gilbert wrote:
> In linux there is also a move away from the host_number,
> channel_number, target_identifier and LUN tuple used
> traditionally by many Unix SCSI subsystems (most do not
> have the second component: channel_number). At least the
> LUN is not controversial (as long as it is 8 byte!). The
> target_identifier is actually transport dependent (but
> could just be a simple enumeration). The host_number is
> typically an enumeration over PCI addresses but some
> other type of computer buses (e.g. microchannel) could be
> involved.

For some transports, not only the channel but also the Scsi_Host is 
meaningless. Such transports deal only with targets and logical units. 
This includes all multi-protocol + multi-bus or network infrastructures 
such as iSCSI, USB, IEEE 1394.
-- 
Stefan Richter
-=====-=-==- --== --===
http://arcgraph.de/sr/
