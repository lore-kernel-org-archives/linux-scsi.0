From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH] Add new driver for LSI 3ware 9750
Date: Fri, 23 Oct 2009 15:53:09 +0200
Message-ID: <200910231553.09572.bzolnier@gmail.com>
References: <b1bc6a000910201722v28d895cbv25e4959473ff215d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:59139 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725AbZJWNyT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Oct 2009 09:54:19 -0400
Received: by bwz27 with SMTP id 27so909465bwz.21
        for <linux-scsi@vger.kernel.org>; Fri, 23 Oct 2009 06:54:23 -0700 (PDT)
In-Reply-To: <b1bc6a000910201722v28d895cbv25e4959473ff215d@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: adam radford <aradford@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>


Hi,

On Wednesday 21 October 2009 02:22:15 adam radford wrote:
> James, linux-scsi,
> 
> This patch adds a new driver '3w-sas' for the LSI 3ware 9750 6Gb/s
> SAS/SATA-RAID controllers.
> 
> - I have tested this code to work on 32-bit, 64-bit, PAE, PPC-64.
> - This code contains a legacy interface that works with open-source
> smartmontools software at
>   http://sourceforge.net/projects/smartmontools.
> 
> Signed-off-by: Adam Radford <aradford@gmail.com>

This driver seems to contain some code which could be shared with
3w-9xxx driver.  Would it be possible to move the common code to
mini library shared by both drivers to avoid needless duplication?

-- 
Bartlomiej Zolnierkiewicz
