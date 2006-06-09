From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [patch 01/31] drivers/scsi: fix proc_scsi_write to return
	"length" on success with remove-single-device case
Date: Fri, 09 Jun 2006 09:07:46 -0500
Message-ID: <1149862066.3480.0.camel@mulgrave.il.steeleye.com>
References: <200606090523.k595NSAb032228@shell0.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:20185 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S965194AbWFIOHz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Jun 2006 10:07:55 -0400
In-Reply-To: <200606090523.k595NSAb032228@shell0.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@osdl.org
Cc: linux-scsi@vger.kernel.org, suzuki@in.ibm.com

On Thu, 2006-06-08 at 22:23 -0700, akpm@osdl.org wrote:
> From: Suzuki <suzuki@in.ibm.com>
> 
> proc_scsi_write doesn't return the "length" upon successfully removing a
> device; instead it returns 0.  This causes commands like "echo" to redo the
> write(), which ends up in something like,
> 
> $ echo "scsi remove-single-device 0 0 3 0" > /proc/scsi/scsi
> "-bash: echo: write error: No such device or address"
> 
> , even though the device was removed.

A better version of this fix is already in SCSI misc.

James


