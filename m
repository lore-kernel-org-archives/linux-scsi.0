From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] mpt2sas : Enable TLR for SSP TAPE drives
Date: Fri, 13 Nov 2009 08:53:50 -0600
Message-ID: <1258124030.4065.11.camel@mulgrave.site>
References: <20091113082620.GB18271@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:51180 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755575AbZKMOzA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Nov 2009 09:55:00 -0500
In-Reply-To: <20091113082620.GB18271@lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Kashyap, Desai" <kashyap.desai@lsi.com>
Cc: linux-scsi@vger.kernel.org, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

On Fri, 2009-11-13 at 13:56 +0530, Kashyap, Desai wrote:
> The driver is sending vpd page 0, to get a list of supported pages. Then it
> will traverse the list searching for page 0x90. when page 0x90 is present,
> the driver will enable the TLR logic for Tape devices only.  The TLR logic
> will enable the TLR bits in the SCSI_IO for every request. If there is a
> response with MPI2_SCSITASKMGMT_RSP_INVALID_FRAME, the driver will turn off
> the TLR logic.

This is applicable to all SAS drivers, isn't it?  So it should be in the
sas transport class and we should be figuring out how to add it to all
SAS drivers, shouldn't we?

James


