From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [LSF/MM TOPIC] [ATTEND] SR-IOV Management
Date: Tue, 31 Jan 2012 14:02:48 -0500
Message-ID: <alpine.WNT.2.00.1201311356390.3392@N5102REMCQXM4BS.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:45768
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753237Ab2AaTC5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 Jan 2012 14:02:57 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: lsf-pc@lists.linux-foundation.org, linux-scsi@vger.kernel.org

With more and more storage controller hardware supporting SR-IOV in next
couple of years it seems to make sense at this point to discuss, from a
storage stack perspective, managing how we instantiate and manage SR-IOV
virtual functions (VFs).  Currently for hardware that does support SR-IOV,
the management of that functionality is managed entirely by the hardware
device driver.  However, a more dynamic management to how VFs are created
and destroyed (assuming the hardware supports it) may be more desirable
since the most common use case, assigning VFs to virtual guests, also
tends to be very dynamic and fluid.  We also need to consider how VFs
interact with complimentary technology such as NPIV in Fibre Channel.

I'd like to propose that we discuss the following issues to see if a
consensus can be reached about how to deal with them:

* VF instantiation
* VF/NPIV port pairing
* Namespace management
* LUN presentation

Any other subtopics to add to this discussion are obviously welcomed.

Thanks,
Chad

This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

