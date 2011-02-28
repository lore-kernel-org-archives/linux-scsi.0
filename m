From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: RE: [PATCH 0/5]: Proposal for iSCSI Network Configuration
Date: Sun, 27 Feb 2011 22:02:43 -0800
Message-ID: <5E4F49720D0BAD499EE1F01232234BA87226303BCC@AVEXMB1.qlogic.org>
References: <5E4F49720D0BAD499EE1F01232234BA8722624A352@AVEXMB1.qlogic.org>
 <4D6B0781.1050403@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:15408 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817Ab1B1GCs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Feb 2011 01:02:48 -0500
In-Reply-To: <4D6B0781.1050403@cs.wisc.edu>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "open-iscsi@googlegroups.com" <open-iscsi@googlegroups.com>
Cc: James Bottomley <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Lalit Chandivade <lalit.chandivade@qlogic.com>, Harish Zunjarrao <harish.zunjarrao@qlogic.com>, Manish Rangankar <manish.rangankar@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>

>-----Original Message-----
>From: open-iscsi@googlegroups.com [mailto:open-iscsi@googlegroups.com] On
>Behalf Of Mike Christie
>Sent: Monday, February 28, 2011 7:55 AM
>To: Vikas Chaudhary
>Cc: James Bottomley; linux-scsi@vger.kernel.org; Lalit Chandivade; Harish
>Zunjarrao; Manish Rangankar; Ravi Anand; open-iscsi
>Subject: Re: [PATCH 0/5]: Proposal for iSCSI Network Configuration
>
>On 02/25/2011 05:05 AM, Vikas Chaudhary wrote:
>> These are set of patches for  configuring network setting for iSCSI
>adapter (qla4xxx) that use private IP address.
>> Please review  proposal/implementation and let us know  the feedback.
>>
>
>Hey,
>
>So what happened with bsg? Why did you switch again?

- For network configuration we found current Netlink interface to be sufficient.
- Initially we tried to implement network configuration using BSG as we needed
  all network parameters in one short from application to driver in vendor
  specific format. Now we are doing same using Netlink interface and TLV mechanism
  (vendor agnostic format)  which is scalable easily for any new network parameter.
- We still need the BSG interface, which we are working on our side, to get the
  adapter FLASH related read/write operations.


This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

