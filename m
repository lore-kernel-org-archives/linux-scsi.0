From: "Ju, Seokmann" <sju@lsil.com>
Subject: RE: return value warnings about scsi_add_host, anything in progre
	 ss?
Date: Mon, 7 Feb 2005 12:25:21 -0500
Message-ID: <0E3FA95632D6D047BA649F95DAB60E570366267D@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain
Received: from mail0.lsil.com ([147.145.40.20]:8643 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S261202AbVBGRZb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Feb 2005 12:25:31 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Matthew Wilcox' <matthew@wil.cx>
Cc: "Ju, Seokmann" <sju@lsil.com>, 'Alexander Stohr' <Alexander.Stohr@gmx.de>, linux-scsi@vger.kernel.org

On Monday, February 07, 2005 11:29 AM, Matthew wrote:
> I don't get a warning from this line, using gcc 3.4.4 20041218
> (prerelease)
> (Debian 3.4.3-7):
> 
> drivers/scsi/megaraid.c: In function `megadev_ioctl':
> drivers/scsi/megaraid.c:3626: warning: ignoring return value of
> `copy_to_user', declared with attribute warn_unused_result
> 
> Were you confused with that warning?

Thank you for your comment.

The driver being referred here is pretty old version and it's been quite
while since LSI move forward to 2.10.9.x for 2.4 kernel support.
Please upgrade the driver to 2.10.9.x.

Thanks,

