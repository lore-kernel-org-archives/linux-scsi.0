From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: RE: FW: [PATCH] iscsiadm: Add netconfig support in iscsiadm and
	iscsid
Date: Wed, 27 Apr 2011 00:05:44 -0700
Message-ID: <5E4F49720D0BAD499EE1F01232234BA8728AB03584@AVEXMB1.qlogic.org>
References: <5E4F49720D0BAD499EE1F01232234BA8728AB02FEF@AVEXMB1.qlogic.org>
 <20110426112005.GY32595@reaktio.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:51383
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751295Ab1D0HFw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Apr 2011 03:05:52 -0400
In-Reply-To: <20110426112005.GY32595@reaktio.net>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?iso-8859-1?Q?Pasi_K=E4rkk=E4inen?= <pasik@iki.fi>, "open-iscsi@googlegroups.com" <open-iscsi@googlegroups.com>
Cc: "James.Bottomley@suse.de" <James.Bottomley@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Lalit Chandivade <lalit.chandivade@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>, Harish Zunjarrao <harish.zunjarrao@qlogic.com>

>-----Original Message-----
>From: Pasi K=E4rkk=E4inen [mailto:pasik@iki.fi]
>Sent: Tuesday, April 26, 2011 4:50 PM
>To: open-iscsi@googlegroups.com
>Cc: James.Bottomley@suse.de; Mike Christie; linux-scsi@vger.kernel.org=
;
>Vikas Chaudhary; Lalit Chandivade; Ravi Anand; Harish Zunjarrao
>Subject: Re: FW: [PATCH] iscsiadm: Add netconfig support in iscsiadm a=
nd
>iscsid
>
>On Fri, Apr 22, 2011 at 09:24:15PM -0700, Vikas Chaudhary wrote:
>> Added open-iscsi group is CC list.
>>
>> From: Lalit Chandivade <lalit.chandivade@qlogic.com>
>>
>> 1. Current status:
>> Using iscsiadm one cannot do any network configuration for qla4xxx
>adapters.
>> However an iface is created for the qla4xxx ports using the hwaddres=
s.
>>
>> \# ls /etc/iscsi/ifaces/
>> iface.example  iface0  qla4xxx.00:0e:1e:04:8b:2a
>qla4xxx.00:0e:1e:04:8b:2e
>>
>> This allows user to issue sendtargets via the qla4xxx iscsi offload.
>>
>> 2. Current Proposal:
>> Current proposal is to allow iscsiadm to configure the network setti=
ngs
>for qla4xxx ports.
>>
>
>Hello,
>
>Configuring jumbo frames for qla4xxx interfaces is not supposed
>to be done using iscsiadm? One still needs qlogic (vendor) specific
>tool for that?
>
>Or did I miss something?
>

Current patch supports only basic network configuration, it does not su=
pport
MTU/jumbo frame configuration. We are planning to add more features lik=
e
this latter once initial network configuration patch is accepted.

This message and any attached documents contain information from QLogic=
 Corporation or its wholly-owned subsidiaries that may be confidential.=
 If you are not the intended recipient, you may not read, copy, distrib=
ute, or use this information. If you have received this transmission in=
 error, please notify the sender immediately by reply e-mail and then d=
elete this message.

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
