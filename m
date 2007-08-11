From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [patch 05/30] drivers/scsi/pcmcia/nsp_cs.c: remove kernel 2.4
	code
Date: Fri, 10 Aug 2007 21:01:59 -0400
Message-ID: <1186794119.6334.18.camel@localhost.localdomain>
References: <200708102150.l7ALoZTO011329@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:45245 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757627AbXHKBCA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Aug 2007 21:02:00 -0400
In-Reply-To: <200708102150.l7ALoZTO011329@imap1.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: linux-scsi@vger.kernel.org, bunk@stusta.de

On Fri, 2007-08-10 at 14:50 -0700, akpm@linux-foundation.org wrote:
> From: Adrian Bunk <bunk@stusta.de>

You're not just removing the 2.4 code ... you're also removing the rcs
tags ... that's OK if the maintainer is fine with this, but it would
help to say this in the change log.

James


