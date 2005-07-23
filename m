From: Johann Hanne <jhml@gmx.net>
Subject: Re: Is it possible to support a sector size 8192
Date: Sat, 23 Jul 2005 15:31:19 +0200
Message-ID: <200507231531.19650.jhml@gmx.net>
References: <OFC69A050A.B893AF16-ON88257046.007534A8-88257046.00754AFA@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pop.gmx.net ([213.165.64.20]:31920 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S261676AbVGWLVt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 23 Jul 2005 07:21:49 -0400
In-Reply-To: <OFC69A050A.B893AF16-ON88257046.007534A8-88257046.00754AFA@us.ibm.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bryan Henderson <hbryan@us.ibm.com>
Cc: Steve McIntyre <steve@einval.com>, linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, smcintyre@software.plasmon.com

It talks to it via /dev/sg*, i.e.

mount -t udo /dev/sga /mnt/udo

On Friday 22 July 2005 23:21, Bryan Henderson wrote:
> >we've started shipping a userland filesystem
> >driver for UDO based on FUSE.
>
> How does the userland filesystem driver talk to the device?
