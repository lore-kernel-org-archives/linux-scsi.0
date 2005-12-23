From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: scsi_run_queue oops
Date: Fri, 23 Dec 2005 23:15:14 +0100
Message-ID: <1135376114.2941.29.camel@laptopd505.fenrus.org>
References: <20051223201227.GA7020@redhat.com>
Reply-To: arjan@infradead.org
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:43976 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1161071AbVLWWPT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Dec 2005 17:15:19 -0500
In-Reply-To: <20051223201227.GA7020@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dave Jones <davej@redhat.com>
Cc: linux-scsi@vger.kernel.org

On Fri, 2005-12-23 at 15:12 -0500, Dave Jones wrote:
> I got a report from a user who periodically sees
> an oops in this function in our 2.6.14.3 based update.
> 
> Does this look familiar to anyone?
> 
> Unable to handle kernel NULL pointer dereference
>   printing eip:
> *pde = 00426001
> Oops: 0000 [#1]
> SMP
> Modules linked in: sata_nv libata scsi_mod e1000 nfs lockd nfs_acl sunrpc
> CPU:    0

> The user mentions that the workstation is actually diskless, so I'm
> puzzled why we're doing SCSI IO at all, but nevertheless...

it seems to at least have an nvidia sata controller....
(and no firewire or usb yet at this point)

