From: Oliver Neukum <oliver@neukum.org>
Subject: Re: [PATCH] pull scsi_scan_host out of scsi_add_host
Date: Tue, 8 Jul 2003 11:03:17 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200307081103.17131.oliver@neukum.org>
References: <20030707143056.GA1177@lst.de> <20030708080334.GA2451@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from Mail1.kontent.de ([81.88.34.36]:63400 "EHLO Mail1.KONTENT.De")
	by vger.kernel.org with ESMTP id S265552AbTGHItd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jul 2003 04:49:33 -0400
In-Reply-To: <20030708080334.GA2451@beaverton.ibm.com>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>, Christoph Hellwig <hch@lst.de>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

Am Dienstag, 8. Juli 2003 10:03 schrieb Mike Anderson:
> Christoph Hellwig [hch@lst.de] wrote:
> > As Douglas mentioned on this list a while ago there's hardware these
> > days where we don't want to automatically perform an initial bus scan
> > in scsi_add_host.  Currently we only have ieee1394 in the tree but
> > I can imagine more uses like iscsi or certain fc setups.
> > 
> > This patch removes the call to scsi_scan_host from scsi_add_host
> > and moves it into the drivers that want in.
> 
> Would we want to make a symmetric interface and pull the
> unscan out of scsi_remove_host also?

Unless you are talking about multipath, you have to forget
all devices connected to a controller, so what sense would
it make?

Philosophically speaking, scanning is an operation that cannot
be simply undone. You can undo device/driver bindings but you
cannot undo a bus scan.

	Regards
		Oliver

