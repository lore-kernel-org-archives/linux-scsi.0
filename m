From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] scsi_transport_sas.c - mapping the rphy channel equal to the port identifier
Date: Sat, 14 Jan 2006 12:30:28 +0100
Message-ID: <20060114113028.GB19567@lst.de>
References: <F331B95B72AFFB4B87467BE1C8E9CF5F1AA7E8@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:13202 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S932221AbWANLam (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 14 Jan 2006 06:30:42 -0500
Content-Disposition: inline
In-Reply-To: <F331B95B72AFFB4B87467BE1C8E9CF5F1AA7E8@NAMAIL2.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>
Cc: linux-scsi@vger.kernel.org, hch@lst.de, James.Bottomley@steeleye.com

On Fri, Jan 13, 2006 at 04:25:17PM -0700, Moore, Eric wrote:
> Remapping the channel number to the port identifier.
> 
> We will be mapping the RAID volumes in mptsas to a reserved channel that
> is one larger than the anticapated number of ports on the direct
> attached host
> adapter.
> 
> Signed-off-by: Eric Moore <Eric.Moore@lsil.com>

Ack, this makes quite a bit more sense than the previous one.

