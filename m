From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [RFC-V2 PATCH 4/5] iscsi_transport: show network configuration
 in sysfs
Date: Wed, 13 Apr 2011 22:07:41 -0500
Message-ID: <4DA664FD.1040301@cs.wisc.edu>
References: <1301769261-29896-1-git-send-email-vikas.chaudhary@qlogic.com> <1301769261-29896-5-git-send-email-vikas.chaudhary@qlogic.com> <4DA5D690.3040501@cs.wisc.edu> <DBFB1B45AF80394ABD1C807E9F28D1570265AEAF2E@BLRX7MCDC203.AMER.DELL.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:38392 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758646Ab1DNDHz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Apr 2011 23:07:55 -0400
In-Reply-To: <DBFB1B45AF80394ABD1C807E9F28D1570265AEAF2E@BLRX7MCDC203.AMER.DELL.COM>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shyam_Iyer@Dell.com
Cc: open-iscsi@googlegroups.com, vikas.chaudhary@qlogic.com, James.Bottomley@suse.de, linux-scsi@vger.kernel.org, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, waie@broadcom.com, mchan@broadcom.com

On 04/13/2011 05:47 PM, Shyam_Iyer@Dell.com wrote:
>>
>> If we add a vlan sysfs file to the iscsi_iface, to export the info was
>> bnx2i going call iscsi_create_iface for each vlan? If so I am not sure
>> what bnx2i will use for the iface_num. It is supposed to be persistent,
>> right?
>>
>
> Would iscsiadm be used to create the vlan.. This would be introducing another way to create vlans..

Yes, iscsiadm. We already manage the other net settings for these cards 
with iscsiadm. Originally, we wanted to just use the normal net tools, 
but that was not allowed, so we do not have very many options.
