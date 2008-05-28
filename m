From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 3/3] bnx2i: Add bnx2i iSCSI driver.
Date: Tue, 27 May 2008 23:39:31 -0400
Message-ID: <483CD3F3.6070308@garzik.org>
References: <ada8wy07osq.fsf@cisco.com> <1211578969.26900.5.camel@dhcp-10-13-110-217.broadcom.com> <adave0z24o4.fsf@cisco.com> <20080527.125247.73979652.davem@davemloft.net> <1211935729.18326.185.camel@dell>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [207.36.208.214] ([207.36.208.214]:39654 "EHLO mail.dvmed.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751304AbYE1DlS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 May 2008 23:41:18 -0400
In-Reply-To: <1211935729.18326.185.camel@dell>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Chan <mchan@broadcom.com>
Cc: David Miller <davem@davemloft.net>, rdreier@cisco.com, anilgv@broadcom.com, michaelc@cs.wisc.edu, netdev <netdev@vger.kernel.org>, linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com

Michael Chan wrote:
> If we change the implementation to use a separate IP address and
> separate MAC address for iSCSI, will it be acceptable?  The iSCSI IP/MAC
> addresses will be unknown to the Linux TCP stack and so no sharing of
> the 4-tuple space will be needed.
> 
> The patches will be very similar, except that all inet calls and
> notifiers will be removed.


IMO a totally separate MAC and IP would definitely be preferred...

	Jeff


