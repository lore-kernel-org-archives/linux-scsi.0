From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [patch 02/25] drivers/scsi/advansys.c: cleanups
Date: Wed, 23 May 2007 18:21:31 -0500
Message-ID: <1179962491.5569.62.camel@mulgrave.il.steeleye.com>
References: <200705232141.l4NLfZ1x001158@shell0.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:38340 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755287AbXEWXVc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 May 2007 19:21:32 -0400
In-Reply-To: <200705232141.l4NLfZ1x001158@shell0.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: linux-scsi@vger.kernel.org, bunk@stusta.de

On Wed, 2007-05-23 at 14:41 -0700, akpm@linux-foundation.org wrote:
> From: Adrian Bunk <bunk@stusta.de>
> 
> - remove the unneeded advansys.h
> - remove the unused advansys_setup()

This isn't quite right, though, is it?  advansys_setup() should be used.

It looks like there was a bogus conversion away from init/main.c which
left the function dangling.  Isn't the correct thing to do to wire it up
in advansys_detect() which is where it should have been in the first
place.

James


