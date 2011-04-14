From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: RE: [RFC-V2 PATCH 4/5] iscsi_transport: show network configuration
 in sysfs
Date: Wed, 13 Apr 2011 21:15:56 -0700
Message-ID: <5E4F49720D0BAD499EE1F01232234BA8728A9D490A@AVEXMB1.qlogic.org>
References: <1301769261-29896-1-git-send-email-vikas.chaudhary@qlogic.com>
 <1301769261-29896-5-git-send-email-vikas.chaudhary@qlogic.com>
 <4DA52525.3020405@cs.wisc.edu> <4DA5294C.8040305@cs.wisc.edu>
 <5E4F49720D0BAD499EE1F01232234BA8728A8CB623@AVEXMB1.qlogic.org>
 <4DA5D2DF.5080806@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:41188 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062Ab1DNEQF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Apr 2011 00:16:05 -0400
In-Reply-To: <4DA5D2DF.5080806@cs.wisc.edu>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "open-iscsi@googlegroups.com" <open-iscsi@googlegroups.com>, Mike Christie <michaelc@cs.wisc.edu>
Cc: "James.Bottomley@suse.de" <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Lalit Chandivade <lalit.chandivade@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>, "Jayamohan.Kallickal@Emulex.Com" <Jayamohan.Kallickal@Emulex.Com>

>-----Original Message-----
>From: open-iscsi@googlegroups.com [mailto:open-iscsi@googlegroups.com] On
>Behalf Of Mike Christie
>Sent: Wednesday, April 13, 2011 10:14 PM
>To: open-iscsi@googlegroups.com
>Cc: Vikas Chaudhary; James.Bottomley@suse.de; linux-scsi@vger.kernel.org;
>Lalit Chandivade; Ravi Anand; Jayamohan.Kallickal@Emulex.Com
>Subject: Re: [RFC-V2 PATCH 4/5] iscsi_transport: show network configuration
>in sysfs
>
>On 04/13/2011 09:48 AM, Vikas Chaudhary wrote:
>>
>>
>>> -----Original Message-----
>>> From: Mike Christie [mailto:michaelc@cs.wisc.edu]
>>> Sent: Wednesday, April 13, 2011 10:11 AM
>>> To: Vikas Chaudhary
>>> Cc: James.Bottomley@suse.de; linux-scsi@vger.kernel.org; open-
>>> iscsi@googlegroups.com; Lalit Chandivade; Ravi Anand;
>>> Jayamohan.Kallickal@Emulex.Com
>>> Subject: Re: [RFC-V2 PATCH 4/5] iscsi_transport: show network
>configuration
>>> in sysfs
>>>
>>> On 04/12/2011 11:23 PM, Mike Christie wrote:
>>>> Do we want to make the kernel iscsi iface more generic or maybe just
>>>> rename it to reflect it is just based on net settings?
>>>>
>>>> The issue with making it more generic is that with the current drivers,
>>>> we do not care what info like the initiatorname in the kernel code.
>That
>>>> is all handled in userspace because all the session management is
>there,
>>>> so there is no point in adding that complexity here.
>>>
>>> I take part of this back. We set the iscsi iface name and initiator name
>>> on the session right now. We need that info for relogin type of
>>> situations where iscsid might have died and we need to know the
>>> initiatorname to use. We cannot read it from a disk, because that disk
>>> might be the one are are relogging into.
>>>
>>> It might not hurt to make the kernel's iscsi ifaces abstraction more
>>> general.
>>
>> Yes and also to reflect correct status of network settings it will be
>> good to have iscsi_iface in the kernel. This is useful in a case where
>> user set DHCP settings then we can reflect IP addresses and other
>> settings in the kernel iface.
>>
>
>How come you did not export some values like the vlan in the iscsi iface?
>

Currently we have partial implementation of VLAN. iscsi_transport supports
VLAN set operation but we need to implement this in iscsiadm and export
VLAN to sysfs iface. We will add this support in our next patches.


This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

