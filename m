From: Mark Haverkamp <markh@osdl.org>
Subject: Re: aacraid driver question
Date: Mon, 25 Aug 2003 12:27:04 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1061839624.10450.4.camel@markh1.pdx.osdl.net>
References: <0998F43EAD645A47B3F6507196DD70EA2568C6@OTCEXC01>
	 <20030825202139.A10609@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:4053 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S262222AbTHYT1I (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Aug 2003 15:27:08 -0400
In-Reply-To: <20030825202139.A10609@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: 'Christoph Hellwig' <hch@infradead.org>
Cc: Mark Salyzyn <mark_salyzyn@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Mon, 2003-08-25 at 12:21, 'Christoph Hellwig' wrote:

> Well, that's exactly what scsi_rescan_device is for.  Mark (H.), could you
> try to use it in your 2.6 driver instead?
> 
I'll take a look into doing this.

Mark.
-- 
Mark Haverkamp <markh@osdl.org>

