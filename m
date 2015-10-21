From: Jos van Wolput <wolput@openmailbox.org>
Subject: Fwd: Re: Fwd: linux-image-4.3.0-rc5-amd64 fails to attach usb storage
 device
Date: Wed, 21 Oct 2015 10:36:20 +0800
Message-ID: <5626FA24.9080807@openmailbox.org>
References: <Pine.LNX.4.44L0.1510201043380.1855-100000@iolanthe.rowland.org>
Reply-To: wolput@on.nl
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp12.openmailbox.org ([62.4.1.46]:39243 "EHLO
	smtp12.openmailbox.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269AbbJUCnV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Oct 2015 22:43:21 -0400
In-Reply-To: <Pine.LNX.4.44L0.1510201043380.1855-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Bug ID: 106321
Summary: linux-kernel-4.3-rc5 fails to attach usb storage device

-------- Forwarded Message --------
Subject: Re: Fwd: linux-image-4.3.0-rc5-amd64 fails to attach usb storage device
Date: Tue, 20 Oct 2015 10:44:25 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: wolput@on.nl
CC: linux-usb@vger.kernel.org

On Tue, 20 Oct 2015, Jos van Wolput wrote:

> -------- Forwarded Message --------
> Subject: linux-image-4.3.0-rc5-amd64 fails to attach usb storage device
> Date: Tue, 20 Oct 2015 12:01:41 +0800
> From: Jos van Wolput <wolput@openmailbox.org>
> Reply-To: wolput@on.nl
> To: Debian Bug Tracking System <submit@bugs.debian.org>
>
> Package: linux-image-4.3.0-rc5-amd64
> Version: 4.3~rc5-1~exp1
> Severity: important
>
> Dear Maintainer,
>
> After upgrading linux-image-4.2.0-1-amd64 (4.2.3-2) from unstable to linux-image-4.3.0-rc5-amd64 from experimental my Verbatim usb flash drive
> is detected but fails to attach.
> Using kernel 4.2.3-2 this device is properly detected and attached.
>
> Please see the attached kernel.log
>
> -- System Information:
> Debian Release: sid + experimental
> Architecture: amd64 (x86_64)
> Kernel: linux-image-4.3.0-rc5-amd64
> Systemd: 227-2

This looks like a SCSI problem, not a USB problem.  Please post this to
the linux-scsi mailing list.

Alan Stern




