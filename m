From: Roman Zippel <zippel@linux-m68k.org>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.1
Date: Tue, 2 Dec 2003 15:11:07 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0312021459200.26104@serv>
References: <03120118001300.08627@naveenb-lnx.cisco.com>
 <Pine.LNX.4.58.0312011655240.26106@serv> <03120217260300.01630@naveenb-lnx.cisco.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from scrub.xs4all.nl ([194.109.195.176]:22030 "EHLO scrub.xs4all.nl")
	by vger.kernel.org with ESMTP id S262118AbTLBOLa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Dec 2003 09:11:30 -0500
In-Reply-To: <03120217260300.01630@naveenb-lnx.cisco.com>
List-Id: linux-scsi@vger.kernel.org
To: Naveen Burmi <naveenb@cisco.com>
Cc: hch@infradead.org, linux-scsi@vger.kernel.org

Hi,

On Tue, 2 Dec 2003, Naveen Burmi wrote:

> > You probably mean the page cache and it's normal that a page can be
> > modified, while it's written out.
>
> Our assumption so far was that if a buffer is given to SCSI HBA driver, then
> nobody can touch the buffer until the HBA says that he is done with the
> buffer. It seems that this assumption isn't true. Can you give an instance
> where somebody (probably buffer cache) will modify the buffer which is handed
> over to an HBA driver?

You only need to mmap a file and write to it. The vm will try to write the
dirty pages back to the storage, but it will not unmap the pages, so the
the process can continue writing to them.

bye, Roman
