From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [2.6 patch] SCSI: cleanups
Date: Mon, 28 Mar 2005 09:21:45 -0600
Message-ID: <1112023305.5531.2.camel@mulgrave>
References: <20050327202139.GQ4285@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:45520 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261865AbVC1PWw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Mar 2005 10:22:52 -0500
In-Reply-To: <20050327202139.GQ4285@stusta.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@stusta.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

On Sun, 2005-03-27 at 22:21 +0200, Adrian Bunk wrote:
> This patch contains the following cleanups:
[..]

No to all of this:

> - remove the following unused functions:
>   - scsi.h: print_driverbyte
>   - scsi.h: print_hostbyte
> - #if 0 the following unused functions:
>   - constants.c: scsi_print_hostbyte
>   - constants.c: scsi_print_driverbyte

These are useful to those of us who debug drivers.

> - remove the following unneeded EXPORT_SYMBOL's:
>   - hosts.c: scsi_host_lookup
>   - scsi.c: scsi_device_cancel
>   - scsi_lib.c: scsi_device_resume

These are part of the SCSI API.

James


