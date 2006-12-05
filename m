From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [Bug 7026] CD/DVD burning with USB writer doesn't work
Date: Tue, 05 Dec 2006 16:58:26 -0600
Message-ID: <1165359506.2785.37.camel@mulgrave.il.steeleye.com>
References: <Pine.LNX.4.44L0.0612051546250.6667-100000@iolanthe.rowland.org>
	 <1165355432.2785.20.camel@mulgrave.il.steeleye.com>
	 <4575f6c6.RvoLkLFpmxoSf6pC%Joerg.Schilling@fokus.fraunhofer.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:57136 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965823AbWLEW6h (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Dec 2006 17:58:37 -0500
In-Reply-To: <4575f6c6.RvoLkLFpmxoSf6pC%Joerg.Schilling@fokus.fraunhofer.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>
Cc: stern@rowland.harvard.edu, schilling@fokus.fraunhofer.de, linux-scsi@vger.kernel.org, dgilbert@interlog.com

On Tue, 2006-12-05 at 23:46 +0100, Joerg Schilling wrote:
> I am afraid, you seem to missunderstand things.
> 
> This parameter is not related to something you may call "block layer", it is 
> rather related to the low level SCSI transport. If the value is stored in a 
> higher layer, it is not stored in the layer where it belongs to.
> 
> If you like to take care of clean interfaces, make sure that this parameter is 
> moved to the right place in the code.

The patch Alan posted is returning the max_sectors count from the block
layer, which is a block, not a SCSI parameter ... so what is it that you
actually want?

James


