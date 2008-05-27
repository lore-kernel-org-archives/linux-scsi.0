From: "Michael Chan" <mchan@broadcom.com>
Subject: Re: [PATCH 3/3] bnx2i: Add bnx2i iSCSI driver.
Date: Tue, 27 May 2008 12:17:54 -0700
Message-ID: <1211915874.18326.101.camel@dell>
References: <1211418386-18203-1-git-send-email-mchan@broadcom.com>
 <1211418386-18203-4-git-send-email-mchan@broadcom.com>
 <ada8wy07osq.fsf@cisco.com>
 <1211578969.26900.5.camel@dhcp-10-13-110-217.broadcom.com>
 <adave0z24o4.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3145 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755711AbYE0SNN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 May 2008 14:13:13 -0400
In-Reply-To: <adave0z24o4.fsf@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roland Dreier <rdreier@cisco.com>
Cc: Anil Veerabhadrappa <anilgv@broadcom.com>, David Miller <davem@davemloft.net>, michaelc@cs.wisc.edu, netdev <netdev@vger.kernel.org>, linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com

On Tue, 2008-05-27 at 07:38 -0700, Roland Dreier wrote:
>  > 'bnx2id' is the user component in this solution. bnx2id daemon uses
>  > socket calls to bind tcp ports in high range and hands them over to
>  > driver. This is how iscsi driver tries to solve tcp port collision
>  > issue. User daemon communicates with the driver using sysfs and tcp port
>  > related functions are bnx2i_read_tcp_portd_*/bnx2i_write_tcp_portd_*
>  > (reference: bnx2i_sysfs.c)
> 
> So you are creating sockets just to reserve TCP ports to avoid host
> stack clashes with your offload engine?  Wasn't this approach strongly
> rejected (in the context of iWARP) in the past?
> 

We're doing it in userspace, so I don't if that makes it any better or
any worse.

Roland, what do you suggest?  We can do it like cma_alloc_any_port() in
cma.c.

