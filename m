From: Christoph Hellwig <hch@infradead.org>
Subject: Re: I2O enhancement for Adaptec management software
Date: Mon, 5 Apr 2004 11:12:45 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040405111245.A4077@infradead.org>
References: <40712A47.4090903@shadowconnect.com> <1081159378.4679.1.camel@laptop.fenrus.com> <20040405110524.A3987@infradead.org> <20040405101007.GA27710@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:29193 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S261884AbUDEKMr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 Apr 2004 06:12:47 -0400
Content-Disposition: inline
In-Reply-To: <20040405101007.GA27710@devserv.devel.redhat.com>; from arjanv@redhat.com on Mon, Apr 05, 2004 at 12:10:08PM +0200
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjanv@redhat.com>
Cc: Markus Lidel <Markus.Lidel@shadowconnect.com>, linux-scsi@vger.kernel.org

On Mon, Apr 05, 2004 at 12:10:08PM +0200, Arjan van de Ven wrote:
> does that matter really ?
> Does SG_IO specify "it's scsi" or "it's native format" :)

SG_IO is for scsi passthrough.  now you could invent fake scsi command
opcodes for native messages, but at that point it starts to get silly.

