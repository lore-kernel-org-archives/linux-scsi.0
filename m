From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] scsi: fix use-after-free in scsi_init_io()
Date: Mon, 16 Aug 2010 17:04:49 +0200
Message-ID: <4C695391.8050805@kernel.org>
References: <4C6947E5.2080208@kernel.org> <1281971186.8326.1.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:56497 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754411Ab0HPPHo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Aug 2010 11:07:44 -0400
In-Reply-To: <1281971186.8326.1.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Linux SCSI List <linux-scsi@vger.kernel.org>, stable@kernel.org

Hello,

On 08/16/2010 05:06 PM, James Bottomley wrote:
> Thanks for the bug report.  The fix is a bit heavy handed; what about
> this?

Yeap, sure.  Looks good to me.

-- 
tejun
