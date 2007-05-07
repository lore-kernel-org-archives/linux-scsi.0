From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [patch 16/30] drivers/scsi/aic7xxx_old: Convert to generic
	boolean-values
Date: Mon, 07 May 2007 14:50:19 -0500
Message-ID: <1178567419.3729.44.camel@mulgrave.il.steeleye.com>
References: <200704260735.l3Q7ZIj7024253@shell0.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:43288 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754790AbXEGTvE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 May 2007 15:51:04 -0400
In-Reply-To: <200704260735.l3Q7ZIj7024253@shell0.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: linux-scsi@vger.kernel.org, ricknu-0@student.ltu.se

On Thu, 2007-04-26 at 00:35 -0700, akpm@linux-foundation.org wrote:
> From: Richard Knutsson <ricknu-0@student.ltu.se>
> 
> Convert:
> FALSE -> false
> TRUE  -> true

NAK'd by maintainer.

James


