From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] aic79xx: convert qfrozen to atomic_t
Date: Tue, 7 Feb 2006 18:57:53 +0000
Message-ID: <20060207185753.GB23340@infradead.org>
References: <43E851D2.1060306@suse.de> <20060207110055.GA13539@infradead.org> <43E884EF.5040704@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:33438 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932110AbWBGS5x (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Feb 2006 13:57:53 -0500
Content-Disposition: inline
In-Reply-To: <43E884EF.5040704@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, "emmanuel.fuste" <emmanuel.fuste@laposte.net>

On Tue, Feb 07, 2006 at 12:30:55PM +0100, Hannes Reinecke wrote:
> As in
> 
> void
> ahd_freeze_simq(struct ahd_softc *ahd)
> {
> 	scsi_block_requests(ahd->platform_data->host);
> }
> 
> ?

Yes.

