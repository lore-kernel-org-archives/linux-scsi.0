From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] isd200: Allocate sense_buffer for hacked up scsi_cmnd
Date: Wed, 12 Mar 2008 11:10:13 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0803121109210.4595-100000@iolanthe.rowland.org>
References: <47D7D670.40306@panasas.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:49311 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751445AbYCLPKO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Mar 2008 11:10:14 -0400
In-Reply-To: <47D7D670.40306@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Sven Schnelle <svens@stackframe.org>, linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Andrew Morton <akpm@linux-foundation.org>

On Wed, 12 Mar 2008, Boaz Harrosh wrote:

> Since the separation of sense_buffer from scsi_cmnd, Drivers that hack their
> own struct scsi_cmnd like here isd200, must also take care of their own
> sense_buffer.

Did you run this through checkpatch?

Acked-by: Alan Stern <stern@rowland.harvard.edu>

Alan Stern

