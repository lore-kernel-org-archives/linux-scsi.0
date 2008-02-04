From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: dmesg spam
Date: Mon, 4 Feb 2008 15:24:55 +0100
Message-ID: <200802041524.55700.bzolnier@gmail.com>
References: <20080203143033.cfea0501.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.182]:42955 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526AbYBDOLs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2008 09:11:48 -0500
Received: by wa-out-1112.google.com with SMTP id v27so2963131wah.23
        for <linux-scsi@vger.kernel.org>; Mon, 04 Feb 2008 06:11:47 -0800 (PST)
In-Reply-To: <20080203143033.cfea0501.akpm@linux-foundation.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-scsi@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, Jeff Garzik <jeff@garzik.org>

On Sunday 03 February 2008, Andrew Morton wrote:
> 
> With latest -mm, running fc8 I am getting this in the logs,
                           ^^^
=> SCSI/libata

cc:ing Jeff

> once per second.
> 
> sr0: CDROM not ready.  Make sure there is a disc in the drive.
> sr0: CDROM not ready.  Make sure there is a disc in the drive.
> sr0: CDROM not ready.  Make sure there is a disc in the drive.
> sr0: CDROM not ready.  Make sure there is a disc in the drive.
> sr0: CDROM not ready.  Make sure there is a disc in the drive.
> sr0: CDROM not ready.  Make sure there is a disc in the drive.
> sr0: CDROM not ready.  Make sure there is a disc in the drive.
> sr0: CDROM not ready.  Make sure there is a disc in the drive.
> sr0: CDROM not ready.  Make sure there is a disc in the drive.
