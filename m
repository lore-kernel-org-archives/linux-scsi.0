From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [usb-storage] Time to allow MODE SENSE for USB disk-type storage devices?
Date: Tue, 9 Mar 2004 17:43:53 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040309174353.A15780@beaverton.ibm.com>
References: <Pine.LNX.4.44L0.0403081046190.1187-100000@ida.rowland.org> <20040308201328.GA13708@apps.cwi.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:16884 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S262549AbUCJBoR
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Mar 2004 20:44:17 -0500
Content-Disposition: inline
In-Reply-To: <20040308201328.GA13708@apps.cwi.nl>; from Andries.Brouwer@cwi.nl on Mon, Mar 08, 2004 at 09:13:29PM +0100
List-Id: linux-scsi@vger.kernel.org
To: Andries Brouwer <Andries.Brouwer@cwi.nl>
Cc: Alan Stern <stern@rowland.harvard.edu>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, USB Storage List <usb-storage@lists.one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>

Andries or others -

Can you elaborate on this comment in sd.c? Do you have a device that hangs
with the current kernel when asking for more than 4 bytes here? Is it USB
storage?

	/*
	 * First attempt: ask for all pages (0x3F), but only 4 bytes.
	 * We have to start carefully: some devices hang if we ask
	 * for more than is available.
	 */
	res = sd_do_mode_sense(SRpnt, 0, 0x3F, buffer, 4, &data);

Per this changeset:

http://linux.bkbits.net:8080/linux-2.5/diffs/drivers/scsi/sd.c@1.53?nav=index.html|src/|src/drivers|src/drivers/scsi|hist/drivers/scsi/sd.c

-- Patrick Mansfield
