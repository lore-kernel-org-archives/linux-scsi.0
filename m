From: Naveen Burmi <naveenb@cisco.com>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.1
Date: Tue, 2 Dec 2003 17:26:03 +0530
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <03120217260300.01630@naveenb-lnx.cisco.com>
References: <03120118001300.08627@naveenb-lnx.cisco.com> <Pine.LNX.4.58.0312011655240.26106@serv>
Reply-To: naveenb@cisco.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:37463 "EHLO
	sj-iport-3.cisco.com") by vger.kernel.org with ESMTP
	id S261957AbTLBLxd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Dec 2003 06:53:33 -0500
In-Reply-To: <Pine.LNX.4.58.0312011655240.26106@serv>
List-Id: linux-scsi@vger.kernel.org
To: Roman Zippel <zippel@linux-m68k.org>
Cc: hch@infradead.org, linux-scsi@vger.kernel.org

On Monday 01 December 2003 09:50 pm, Roman Zippel wrote:

> You probably mean the page cache and it's normal that a page can be
> modified, while it's written out.

Our assumption so far was that if a buffer is given to SCSI HBA driver, then 
nobody can touch the buffer until the HBA says that he is done with the 
buffer. It seems that this assumption isn't true. Can you give an instance 
where somebody (probably buffer cache) will modify the buffer which is handed
over to an HBA driver?

Thanks,
Naveen.
