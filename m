From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [RFC-V2 PATCH 4/5] iscsi_transport: show network configuration
 in sysfs
Date: Tue, 12 Apr 2011 23:40:44 -0500
Message-ID: <4DA5294C.8040305@cs.wisc.edu>
References: <1301769261-29896-1-git-send-email-vikas.chaudhary@qlogic.com> <1301769261-29896-5-git-send-email-vikas.chaudhary@qlogic.com> <4DA52525.3020405@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:41066 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751071Ab1DMEk5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Apr 2011 00:40:57 -0400
In-Reply-To: <4DA52525.3020405@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vikas.chaudhary@qlogic.com
Cc: James.Bottomley@suse.de, linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, Jayamohan.Kallickal@Emulex.Com

On 04/12/2011 11:23 PM, Mike Christie wrote:
> Do we want to make the kernel iscsi iface more generic or maybe just
> rename it to reflect it is just based on net settings?
>
> The issue with making it more generic is that with the current drivers,
> we do not care what info like the initiatorname in the kernel code. That
> is all handled in userspace because all the session management is there,
> so there is no point in adding that complexity here.

I take part of this back. We set the iscsi iface name and initiator name 
on the session right now. We need that info for relogin type of 
situations where iscsid might have died and we need to know the 
initiatorname to use. We cannot read it from a disk, because that disk 
might be the one are are relogging into.

It might not hurt to make the kernel's iscsi ifaces abstraction more 
general.
