From: Mark Haverkamp <markh@osdl.org>
Subject: Re: aacraid driver question
Date: Mon, 25 Aug 2003 13:25:38 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1061843138.10450.10.camel@markh1.pdx.osdl.net>
References: <0998F43EAD645A47B3F6507196DD70EA2568CD@OTCEXC01>
	 <20030825210836.A11567@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:59275 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S262255AbTHYUZm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Aug 2003 16:25:42 -0400
In-Reply-To: <20030825210836.A11567@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: 'Christoph Hellwig' <hch@infradead.org>
Cc: Mark Salyzyn <mark_salyzyn@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Mon, 2003-08-25 at 13:08, 'Christoph Hellwig' wrote:

> Well, we could keep the semantics without the proc_write mess by
> exporting scsi_scan_host_selected as Mark H. did in the patch that
> triggered this thread, but I'd be very unhappy to do that.  We have
> the exported scsi_add_device and scsi_remove_device functions to
> add/remove a selected lun and if possible at all I'd prefer to use those.
> 
> scsi_add_device will return an error it it's not actually present,
> but we don't have a way to remove an existing volume going that route
> unless we find out whether we really meant offlining it.

Correct me if I'm wrong, scsi_rescan_device will not do what we want. 
We need to know whether a device is coming or going and then call either
add or remove device, assuming that it can be determined?

Mark
-- 
Mark Haverkamp <markh@osdl.org>

