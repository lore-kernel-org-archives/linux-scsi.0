From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH] Forcing capacity sizes for block devices
Date: Sun, 20 Dec 2009 18:43:40 +0100
Message-ID: <200912201843.40169.bzolnier@gmail.com>
References: <2f83750a0912200405v77f39a7eifef024cc4cb10a20@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f209.google.com ([209.85.219.209]:61572 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755436AbZLTRpY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 20 Dec 2009 12:45:24 -0500
Received: by ewy1 with SMTP id 1so5528864ewy.28
        for <linux-scsi@vger.kernel.org>; Sun, 20 Dec 2009 09:45:23 -0800 (PST)
In-Reply-To: <2f83750a0912200405v77f39a7eifef024cc4cb10a20@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Clemens Fruhwirth <clemens@endorphin.org>
Cc: linux-scsi@vger.kernel.org, grundler@google.com

On Sunday 20 December 2009 01:05:35 pm Clemens Fruhwirth wrote:
> Make the size attribute of block devices writable via sysfs. This
> allows userspace to force
> device boundaries in cases where the device driver is unable to detect
> the correct size, as
> with spec-incompliant SD card readers. Also see
> http://marc.info/?t=125555550200010&r=1&w=2

Just a wild idea but maybe the current block infrastructure for handling
ATA HPA (see commit db429e9 and e957b60 one) can be used to automatically
detect and workaround the issue?  
--
Bartlomiej Zolnierkiewicz
