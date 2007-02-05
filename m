From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: megaraid_sas : Error message from SYNC CACHE cmd fills up
	kernel log
Date: Mon, 05 Feb 2007 16:46:01 -0600
Message-ID: <1170715561.4517.22.camel@mulgrave.il.steeleye.com>
References: <0631C836DBF79F42B5A60C8C8D4E82298ED151@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:57480 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752502AbXBEWqH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Feb 2007 17:46:07 -0500
In-Reply-To: <0631C836DBF79F42B5A60C8C8D4E82298ED151@NAMAIL2.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Patro, Sumant" <Sumant.Patro@lsi.com>
Cc: linux-scsi@vger.kernel.org, hch@lst.de, "Kolli, Neela" <Neela.Kolli@lsi.com>, "Yang, Bo" <Bo.Yang@lsi.com>

On Mon, 2007-02-05 at 15:14 -0700, Patro, Sumant wrote:
> 1. Shouldn't the OS stop sending the sync cache cmd 
> if it sees it is "Failed" with "Invalid Command" in sense info ?   

Possibly, but supporting a write back cache but not supporting the
command to flush it is unusual (or more likely IDE-like) behaviour.

> 2. Is there a way by which LLD can stop the OS from sending the SYNC
> cmd
> down?

The way all the other raid drivers do it is to intercept the command ...

James


