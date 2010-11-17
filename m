From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 1/3] target: simplify cmd transformation
Date: Wed, 17 Nov 2010 14:46:03 -0800
Message-ID: <1290033963.31890.73.camel@haakon2.linux-iscsi.org>
References: <20101117213847.GA26557@infradead.org>
	 <1290032519.31890.56.camel@haakon2.linux-iscsi.org>
	 <20101117223207.GC26760@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:53493 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935542Ab0KQWvY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Nov 2010 17:51:24 -0500
In-Reply-To: <20101117223207.GC26760@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

On Wed, 2010-11-17 at 17:32 -0500, Christoph Hellwig wrote:
> On Wed, Nov 17, 2010 at 02:21:59PM -0800, Nicholas A. Bellinger wrote:
> > On Wed, 2010-11-17 at 16:38 -0500, Christoph Hellwig wrote:
> > > There is no need for the transport_cdb_transform function pointer,
> > > we can simply call the right code based on the cmd flags.
> > > 
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > > 
> > 
> > Hmmm, it is really less expensive to drop cmd->transport_cdb_transport()
> > and change transport_generic_new_cmd() to require 4 bitwise AND instructions
> > for each bulk SCF_SCSI_DATA_SG_IO_CDB cmd..?
> 
> The pointer bloats every single command in flight, and CPU time is
> getting really cheap these days.  Either way this will get much simpler
> after a few more patches.  See the next one for a first preview.
> 

Committed as f71d81ec15.

Thanks!

> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

