From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [patch 05/30] scsi: remove unnecessary check in
	drivers/scsi/sg.c
Date: Mon, 07 May 2007 13:11:35 -0500
Message-ID: <1178561495.3729.31.camel@mulgrave.il.steeleye.com>
References: <200704260735.l3Q7ZAGn024220@shell0.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:42398 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934430AbXEGSMU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 May 2007 14:12:20 -0400
In-Reply-To: <200704260735.l3Q7ZAGn024220@shell0.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: linux-scsi@vger.kernel.org, snakebyte@gmx.de, dougg@torque.net

On Thu, 2007-04-26 at 00:35 -0700, akpm@linux-foundation.org wrote:
> From: Eric Sesterhenn <snakebyte@gmx.de>
> 
> coverity spotted this (cid #758).  All callers dereference sfp, so we dont
> need this check.  In addition to this, we dereference it earlier in the
> function.

Awaiting ACK from dougg

James


