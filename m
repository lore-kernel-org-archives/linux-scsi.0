From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: RE: [RFC-V2 PATCH 4/5] iscsi_transport: show network configuration
 in sysfs
Date: Wed, 13 Apr 2011 22:54:12 -0700
Message-ID: <5E4F49720D0BAD499EE1F01232234BA8728A9D4921@AVEXMB1.qlogic.org>
References: <1301769261-29896-1-git-send-email-vikas.chaudhary@qlogic.com>
 <1301769261-29896-5-git-send-email-vikas.chaudhary@qlogic.com>
 <4DA52525.3020405@cs.wisc.edu> <4DA5294C.8040305@cs.wisc.edu>
 <5E4F49720D0BAD499EE1F01232234BA8728A8CB623@AVEXMB1.qlogic.org>
 <4DA5D2DF.5080806@cs.wisc.edu>
 <5E4F49720D0BAD499EE1F01232234BA8728A9D490A@AVEXMB1.qlogic.org>
 <4DA683AD.1060802@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:42449
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754854Ab1DNFzH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Apr 2011 01:55:07 -0400
In-Reply-To: <4DA683AD.1060802@cs.wisc.edu>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>, "open-iscsi@googlegroups.com" <open-iscsi@googlegroups.com>
Cc: "James.Bottomley@suse.de" <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Lalit Chandivade <lalit.chandivade@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>, "Jayamohan.Kallickal@Emulex.Com" <Jayamohan.Kallickal@Emulex.Com>

>-----Original Message-----
>From: Mike Christie [mailto:michaelc@cs.wisc.edu]
>Sent: Thursday, April 14, 2011 10:49 AM
>To: open-iscsi@googlegroups.com
>Cc: Vikas Chaudhary; James.Bottomley@suse.de; linux-scsi@vger.kernel.org;
>Lalit Chandivade; Ravi Anand; Jayamohan.Kallickal@Emulex.Com
>Subject: Re: [RFC-V2 PATCH 4/5] iscsi_transport: show network configuration
>in sysfs
>
>On 04/13/2011 11:15 PM, Vikas Chaudhary wrote:
>>
>> Currently we have partial implementation of VLAN. iscsi_transport
>supports
>> VLAN set operation but we need to implement this in iscsiadm and export
>> VLAN to sysfs iface. We will add this support in our next patches.
>>
>
>
>Basically, I just want to know if vlan stuff is going into the
>iscsi_iface class or in some new struct?
>
>For the latter would it be something like:
>
>host
>|
>\-iscsi_iface0
>       |
>       \-iscsi_vlan0
>       |
>       \-iscsi_vlan1
>       |
>       \-iscsi_vlan2
>
>or
>
>host
>|
>\-iscsi_iface1
>       |-vlan0
>\-iscsi_iface2
>       |-vlan1
>\-iscsi_iface3
>       |-vlan2


VLAN will be per iface. So it will be like:

host
|
\-iscsi_iface1
        |-vlan0
\-iscsi_iface2
        |-vlan1
\-iscsi_iface3
        |-vlan2


This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

