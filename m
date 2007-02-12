From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [GIT PATCH] SCSI updates for 2.6.20
Date: Mon, 12 Feb 2007 08:38:40 -0600
Message-ID: <1171291120.3690.0.camel@mulgrave.il.steeleye.com>
References: <1171166252.3373.58.camel@mulgrave.il.steeleye.com>
	 <200702121129.34359.eike-kernel@sf-tec.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:37632 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S964942AbXBLOir (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Feb 2007 09:38:47 -0500
In-Reply-To: <200702121129.34359.eike-kernel@sf-tec.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: linux-scsi@vger.kernel.org, Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Mon, 2007-02-12 at 11:29 +0100, Rolf Eike Beer wrote:
> Am Sonntag, 11. Februar 2007 schrieb James Bottomley:
> > This is the accumulated SCSI tree for 2.6.20.  It is available at
> >
> > master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git
> 
> You once again have not included this two patches Andrew sent you on 20070602:
> 
> [patch 08/33] remove extra newline from info message

This one's waiting on Hannes to ack, since he's working in that driver

> [patch 09/33] Fix scsi/scsi_transport.h compile error

I did look at this one, but I can't find a configuration that will
induce a compile error like the header says.  It's pending further
investigation.

James


