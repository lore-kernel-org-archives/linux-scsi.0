From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 4/5] iscsi_transport: show network configuration in sysfs
Date: Sat, 23 Apr 2011 17:40:11 -0500
Message-ID: <4DB3554B.4080505@cs.wisc.edu>
References: <1303495666-731-1-git-send-email-vikas.chaudhary@qlogic.com> <1303495666-731-5-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:60969 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757277Ab1DWWkY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 23 Apr 2011 18:40:24 -0400
In-Reply-To: <1303495666-731-5-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vikas.chaudhary@qlogic.com
Cc: James.Bottomley@suse.de, linux-scsi@vger.kernel.org, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

On 04/22/2011 01:07 PM, vikas.chaudhary@qlogic.com wrote:
> From: Vikas Chaudhary<vikas.chaudhary@qlogic.com>
>
> To support multiple network addresses per adapter need to have a new way to
> represent network interface (net iface) in sysfs.
>

 From the previous posting's comments you did not handle or respond to 
the comment about linking the sessions to the iface. Basically, I want 
to know how for sessionX you know which iface is being used? For 
example, users want to know the src ip address for the session.

You could make a symlink from the session to the iface or make the iface 
the parent of the session instead of the host then add symlinks to/from, 
for compat with existing tools, the session/host.

We could do this in another patch, but I would then want to wait off on 
sending this patch and the 5/5 to James so we do not have some kernels 
with it and some without.
