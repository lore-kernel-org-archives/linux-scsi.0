From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: [ANNOUNCE] Adaptec SAS/SATA device driver [03/27]
Date: Fri, 18 Feb 2005 00:39:21 +0300
Message-ID: <42150F09.6020309@tls.msk.ru>
References: <4214D5E8.9000907@adaptec.com> <4214EA6E.8020608@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Received: from hobbit.corpit.ru ([81.13.94.6]:3162 "EHLO hobbit.corpit.ru")
	by vger.kernel.org with ESMTP id S261199AbVBQVj0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Feb 2005 16:39:26 -0500
In-Reply-To: <4214EA6E.8020608@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

Jeff Garzik wrote:
> Luben,
[]
> Everyone who submits patches to Linux needs to include a signed-off-by 
> line, and format their emails such that automated scripts will process 
> the emails correctly.

BTW, as this is a completely new driver (for the kernel source anyway),
and there's no "patch" per se here in usual sense (but alot of closely
related new files), I think it'll be better to submit it as a tarball,
not a series of "patches", most of which are with useless comments
(given after the filename the path introduces)... Tarball and a patch
for usual places like Kconfig and Makefiles in the upper-level in the
source tree...  Just IMHO ofcourse.

/mjt
