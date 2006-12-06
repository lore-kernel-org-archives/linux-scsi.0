From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [Bug 7026] CD/DVD burning with USB writer doesn't work
Date: Wed, 06 Dec 2006 11:59:06 -0600
Message-ID: <1165427946.2810.46.camel@mulgrave.il.steeleye.com>
References: <Pine.LNX.4.44L0.0612061105500.3298-100000@iolanthe.rowland.org>
	 <1165423635.2810.33.camel@mulgrave.il.steeleye.com>
	 <4577029f./DIiz5nuoOKd82Zo%Joerg.Schilling@fokus.fraunhofer.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:36013 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S936962AbWLFSFQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Dec 2006 13:05:16 -0500
In-Reply-To: <4577029f./DIiz5nuoOKd82Zo%Joerg.Schilling@fokus.fraunhofer.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>
Cc: stern@rowland.harvard.edu, schilling@fokus.fraunhofer.de, linux-scsi@vger.kernel.org, dgilbert@interlog.com

On Wed, 2006-12-06 at 18:49 +0100, Joerg Schilling wrote:
> Please keep in mind: all CD/DVD burners are SCSI devices.

This is probably semantics, but nowadays, SCSI means SPI (or parallel
SCSI).  I think you're trying to say that they're all devices that obey
the MMC standard?  Which is true, but not really relevant.

> You cannot write or even retrieve special information without SCSI.

James


