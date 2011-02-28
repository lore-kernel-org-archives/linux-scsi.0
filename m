From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: RE: [PATCH 0/5]: Proposal for iSCSI Network Configuration
Date: Mon, 28 Feb 2011 01:34:59 -0800
Message-ID: <5E4F49720D0BAD499EE1F01232234BA87226303BEB@AVEXMB1.qlogic.org>
References: <5E4F49720D0BAD499EE1F01232234BA8722624A352@AVEXMB1.qlogic.org>
 <4D6B0781.1050403@cs.wisc.edu>
 <5E4F49720D0BAD499EE1F01232234BA87226303BCC@AVEXMB1.qlogic.org>
 <4D6B595B.4000109@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:45520 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384Ab1B1JfE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Feb 2011 04:35:04 -0500
In-Reply-To: <4D6B595B.4000109@cs.wisc.edu>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: "open-iscsi@googlegroups.com" <open-iscsi@googlegroups.com>, James Bottomley <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Lalit Chandivade <lalit.chandivade@qlogic.com>, Harish Zunjarrao <harish.zunjarrao@qlogic.com>, Manish Rangankar <manish.rangankar@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>

>-----Original Message-----
>From: Mike Christie [mailto:michaelc@cs.wisc.edu]
>Sent: Monday, February 28, 2011 1:44 PM
>To: Vikas Chaudhary
>Cc: open-iscsi@googlegroups.com; James Bottomley; linux-
>scsi@vger.kernel.org; Lalit Chandivade; Harish Zunjarrao; Manish Rangankar;
>Ravi Anand
>Subject: Re: [PATCH 0/5]: Proposal for iSCSI Network Configuration
>
>On 02/28/2011 12:02 AM, Vikas Chaudhary wrote:
>> - We still need the BSG interface, which we are working on our side, to
>get the
>>    adapter FLASH related read/write operations.
>
>So would that be the operations to do something like store/get targets,
>discovery info, isns, chap, iscsi settings like FirstBurst, etc?

We are planning to add BSG for Vendor specific flash updates like, read/write operations of - NVRAM, firmware and bootcode.

We will use Netlink interface for target discovery info, iscsi settings, login/logout of target.


This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

