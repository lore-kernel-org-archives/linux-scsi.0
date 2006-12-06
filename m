From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [Bug 7026] CD/DVD burning with USB writer doesn't work
Date: Wed, 06 Dec 2006 10:12:28 -0600
Message-ID: <1165421548.2810.17.camel@mulgrave.il.steeleye.com>
References: <Pine.LNX.4.44L0.0612051546250.6667-100000@iolanthe.rowland.org>
	 <1165355432.2785.20.camel@mulgrave.il.steeleye.com>
	 <4575f6c6.RvoLkLFpmxoSf6pC%Joerg.Schilling@fokus.fraunhofer.de>
	 <1165359506.2785.37.camel@mulgrave.il.steeleye.com>
	 <4575fd53.ja06l7+Yx9/C/OYS%Joerg.Schilling@fokus.fraunhofer.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:35145 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S936250AbWLFQRR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Dec 2006 11:17:17 -0500
In-Reply-To: <4575fd53.ja06l7+Yx9/C/OYS%Joerg.Schilling@fokus.fraunhofer.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>
Cc: stern@rowland.harvard.edu, schilling@fokus.fraunhofer.de, linux-scsi@vger.kernel.org, dgilbert@interlog.com

On Wed, 2006-12-06 at 00:14 +0100, Joerg Schilling wrote:
> Well, accept the patch if it works.

It's not about work/not work: it's about correctness.

>  And in case that you don't like it, make sure that the _parameter_ is
> moved to where it belongs: to the low level transport layer.

It's not a low level property; it's a property of the generic queue,
namely the maximum request size.  It exists for devices independent of
SCSI (i.e. you'll want it for IDE and weirder transport attachment CDs
as well).

James


