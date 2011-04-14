From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [RFC-V2 PATCH 4/5] iscsi_transport: show network configuration
 in sysfs
Date: Thu, 14 Apr 2011 00:18:37 -0500
Message-ID: <4DA683AD.1060802@cs.wisc.edu>
References: <1301769261-29896-1-git-send-email-vikas.chaudhary@qlogic.com> <1301769261-29896-5-git-send-email-vikas.chaudhary@qlogic.com> <4DA52525.3020405@cs.wisc.edu> <4DA5294C.8040305@cs.wisc.edu> <5E4F49720D0BAD499EE1F01232234BA8728A8CB623@AVEXMB1.qlogic.org> <4DA5D2DF.5080806@cs.wisc.edu> <5E4F49720D0BAD499EE1F01232234BA8728A9D490A@AVEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:42395 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753132Ab1DNFSv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Apr 2011 01:18:51 -0400
In-Reply-To: <5E4F49720D0BAD499EE1F01232234BA8728A9D490A@AVEXMB1.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: open-iscsi@googlegroups.com
Cc: Vikas Chaudhary <vikas.chaudhary@qlogic.com>, "James.Bottomley@suse.de" <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Lalit Chandivade <lalit.chandivade@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>, "Jayamohan.Kallickal@Emulex.Com" <Jayamohan.Kallickal@Emulex.Com>

On 04/13/2011 11:15 PM, Vikas Chaudhary wrote:
>
> Currently we have partial implementation of VLAN. iscsi_transport supports
> VLAN set operation but we need to implement this in iscsiadm and export
> VLAN to sysfs iface. We will add this support in our next patches.
>


Basically, I just want to know if vlan stuff is going into the 
iscsi_iface class or in some new struct?

For the latter would it be something like:

host
|
\-iscsi_iface0
	|
	\-iscsi_vlan0
	|
	\-iscsi_vlan1
	|
	\-iscsi_vlan2

or

host
|
\-iscsi_iface1
	|-vlan0
\-iscsi_iface2
	|-vlan1
\-iscsi_iface3
	|-vlan2
