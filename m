From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH] Add new driver for LSI 3ware 9750
Date: Thu, 5 Nov 2009 15:45:38 +0100
Message-ID: <200911051545.38102.bzolnier@gmail.com>
References: <b1bc6a000910201722v28d895cbv25e4959473ff215d@mail.gmail.com> <200910231553.09572.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:60673 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757910AbZKEOq3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Nov 2009 09:46:29 -0500
Received: by bwz27 with SMTP id 27so50689bwz.21
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2009 06:46:33 -0800 (PST)
In-Reply-To: <200910231553.09572.bzolnier@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: adam radford <aradford@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>

On Friday 23 October 2009 15:53:09 Bartlomiej Zolnierkiewicz wrote:
> 
> Hi,
> 
> On Wednesday 21 October 2009 02:22:15 adam radford wrote:
> > James, linux-scsi,
> > 
> > This patch adds a new driver '3w-sas' for the LSI 3ware 9750 6Gb/s
> > SAS/SATA-RAID controllers.
> > 
> > - I have tested this code to work on 32-bit, 64-bit, PAE, PPC-64.
> > - This code contains a legacy interface that works with open-source
> > smartmontools software at
> >   http://sourceforge.net/projects/smartmontools.
> > 
> > Signed-off-by: Adam Radford <aradford@gmail.com>
> 
> This driver seems to contain some code which could be shared with
> 3w-9xxx driver.  Would it be possible to move the common code to
> mini library shared by both drivers to avoid needless duplication?

Did you have a chance to look into it?

-- 
Bartlomiej Zolnierkiewicz
