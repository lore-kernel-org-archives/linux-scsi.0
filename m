From: Brian Auld <bauld@lefthandnetworks.com>
Subject: P-OUT clear service action hanging
Date: Mon, 07 Jun 2004 17:23:52 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40C4F908.80403@lefthandnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.lefthandnetworks.com ([207.174.0.250]:63623 "EHLO
	mail.lefthandnetworks.com") by vger.kernel.org with ESMTP
	id S265126AbUFGX2T (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Jun 2004 19:28:19 -0400
Received: from lefthandnetworks.com (unknown [10.0.11.117])
	by mail.lefthandnetworks.com (Postfix) with ESMTP id B5F8D37E54
	for <linux-scsi@vger.kernel.org>; Mon,  7 Jun 2004 17:28:18 -0600 (MDT)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I'm running passthrough commands to a LUN on an MSA1000. My host is 
running RH9. I'm using the sg driver provided with this distribution 
using the SG_IO option to send the passthrough commands.

I have a previously established reservation that I'm trying to clear. 
I'm following the directions in the spec for clearing a a persistent 
reservation - specifically, section 5.5.3.6.5 of SPC-2:

(1) My P-OUT command has a service action set to CLEAR 03h.
(2) In my 24 bytes of data transferred to the target with the command, 
only the reservation
      key field is set to a non-zero value. This value is of course the 
previously registered reservation key.

When I execute this command, my driver hangs until it times out and 
returns with an error.

Any ideas or history with the MSA1000 that makes it not cooperate well 
with P-IN/P-OUT commands?

Thanks,
Brian

