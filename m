From: Linus Torvalds <torvalds@osdl.org>
Subject: Re: [PATCH] qla1820 iomem annotations
Date: Thu, 21 Oct 2004 07:24:58 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0410210724280.2171@ppc970.osdl.org>
References: <20041020235837.GC23987@parcelfarce.linux.theplanet.co.uk>
 <20041021090032.GA1941@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:54406 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S270664AbUJUOZR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Oct 2004 10:25:17 -0400
In-Reply-To: <20041021090032.GA1941@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: viro@parcelfarce.linux.theplanet.co.uk, linux-scsi@vger.kernel.org



On Thu, 21 Oct 2004, Christoph Hellwig wrote:
>
> This breaks old-style PIO support in this driver which is required for the
> Visual Workstations.

Really? It doesn't even seem to change any code, it just adds annotations 
that gcc won't care about anyway.

		Linus
