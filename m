From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [RFC-V2 PATCH 4/5] iscsi_transport: show network configuration
 in sysfs
Date: Mon, 18 Apr 2011 21:41:04 -0500
Message-ID: <4DACF640.2090009@cs.wisc.edu>
References: <1301769261-29896-1-git-send-email-vikas.chaudhary@qlogic.com> <1301769261-29896-5-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:33269 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754021Ab1DSClR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Apr 2011 22:41:17 -0400
In-Reply-To: <1301769261-29896-5-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vikas.chaudhary@qlogic.com
Cc: James.Bottomley@suse.de, linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

Just noticed I forgot to send some comments.

On 04/02/2011 01:34 PM, vikas.chaudhary@qlogic.com wrote:
> |
> |- ipv4-iface-<host_no>-<iface_no>/<-- for ipv4
>                                  |- ipaddress
>                                  |- subnet
>                                  |- gateway
>                                  |- bootproto
>                                  |- state

What does state mean? I thought it was going to be something like port 
up/down/coming up/ or something like that. It instead just indicates if 
it is enabled or not, right?

What about

1. renaming to enabled, having it print out True of enabled and False if 
not.
2. adding a new file for state that indicates the port's state.
3. rename IPOPT_IPv4_PROTOCOL_ENABLE to IPOPT_IPV4_PROTOCOL_ENABLE to 
match ipv6 naming.
