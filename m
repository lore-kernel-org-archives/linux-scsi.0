From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] isci: T10 DIF support
Date: Sat, 28 Jan 2012 12:00:50 -0800
Message-ID: <CAA9_cmeF4_1Mx1tkaMgB1QguU4WgDHi0MaZ6-XbSLFHnHDhc0Q@mail.gmail.com>
References: <20120127191358.27475.26561.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:52059 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547Ab2A1UAv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 28 Jan 2012 15:00:51 -0500
Received: by vbbfc26 with SMTP id fc26so2046755vbb.19
        for <linux-scsi@vger.kernel.org>; Sat, 28 Jan 2012 12:00:50 -0800 (PST)
In-Reply-To: <20120127191358.27475.26561.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Dave Jiang <dave.jiang@intel.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

On Fri, Jan 27, 2012 at 11:14 AM, Dan Williams <dan.j.williams@intel.co=
m> wrote:
> From: Dave Jiang <dave.jiang@intel.com>
>
> This allows the controller to do WRITE_INSERT and READ_STRIP for SAS
> disks that support protection information. SAS disks must be formatte=
d
> with protection information to use this feature via sg_format.
>
> =A0sg3_utils-1.32 -- sg_format version 1.19 20110730
> =A0sg_format usage:
> =A0sg_format --format --verbose --pinfo /dev/sda
>
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---

Sorry, some checkpatch escapes in this one... will resend.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
