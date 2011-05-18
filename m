From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [RFC v2 PATCH 0/2] scsi_transport_fc: Add new rport attributes.
Date: Wed, 18 May 2011 14:45:44 -0400
Message-ID: <alpine.LFD.2.02.1105181443310.7238@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:41424
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933460Ab1ERSpu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 May 2011 14:45:50 -0400
Received: from mail160-ch1 (localhost.localdomain [127.0.0.1])	by
 mail160-ch1-R.bigfish.com (Postfix) with ESMTP id C68F619F02AA	for
 <linux-scsi@vger.kernel.org>; Wed, 18 May 2011 18:45:48 +0000 (UTC)
Received: from CH1EHSMHS032.bigfish.com (snatpool1.int.messaging.microsoft.com
 [10.43.68.248])	by mail160-ch1.bigfish.com (Postfix) with ESMTP id
 87C541480052	for <linux-scsi@vger.kernel.org>; Wed, 18 May 2011 18:45:48
 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a response to the original RFC for adding new rport attributes to the
FC transport layer:

http://marc.info/?l=linux-scsi&m=128828294426031&w=2

The bulk of populating the attribute data was done in the low-level device
driver in that set but a more vendor agnostic method was desired.

This RFC patch set moves the name server calls into the FC transport itself
and utilizes the existing bsg infrastructure to send CT commands.  However,
a method for sending bsg commands from the kernel needed to be devised so
patch one makes the proposed changes to the bsg layer.

The second patch in this set makes the actual changes to the SCSI transport as
well as some changes to the libfc header files to add the needed CT command
definitions.

This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

