From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: RE: [RFC-V2 PATCH 4/5] iscsi_transport: show network configuration
 in sysfs
Date: Tue, 19 Apr 2011 06:47:59 -0700
Message-ID: <5E4F49720D0BAD499EE1F01232234BA8728A9D50C5@AVEXMB1.qlogic.org>
References: <1301769261-29896-1-git-send-email-vikas.chaudhary@qlogic.com>
 <1301769261-29896-5-git-send-email-vikas.chaudhary@qlogic.com>
 <4DACF640.2090009@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:9466 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573Ab1DSNsI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Apr 2011 09:48:08 -0400
In-Reply-To: <4DACF640.2090009@cs.wisc.edu>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: "James.Bottomley@suse.de" <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "open-iscsi@googlegroups.com" <open-iscsi@googlegroups.com>, Lalit Chandivade <lalit.chandivade@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>

>-----Original Message-----
>From: Mike Christie [mailto:michaelc@cs.wisc.edu]
>Sent: Tuesday, April 19, 2011 8:11 AM
>To: Vikas Chaudhary
>Cc: James.Bottomley@suse.de; linux-scsi@vger.kernel.org; open-
>iscsi@googlegroups.com; Lalit Chandivade; Ravi Anand
>Subject: Re: [RFC-V2 PATCH 4/5] iscsi_transport: show network configuration
>in sysfs
>
>Just noticed I forgot to send some comments.
>
>On 04/02/2011 01:34 PM, vikas.chaudhary@qlogic.com wrote:
>> |
>> |- ipv4-iface-<host_no>-<iface_no>/<-- for ipv4
>>                                  |- ipaddress
>>                                  |- subnet
>>                                  |- gateway
>>                                  |- bootproto
>>                                  |- state
>
>What does state mean? I thought it was going to be something like port
>up/down/coming up/ or something like that. It instead just indicates if
>it is enabled or not, right?
>

Yes, state indicates ipv4/ipv6 enabled or not.

>What about
>
>1. renaming to enabled, having it print out True of enabled and False if
>not.
>2. adding a new file for state that indicates the port's state.
>3. rename IPOPT_IPv4_PROTOCOL_ENABLE to IPOPT_IPV4_PROTOCOL_ENABLE to
>match ipv6 naming.

Ok. I will take care of all three comments in final patch.

This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

