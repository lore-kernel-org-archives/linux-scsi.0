From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: megaraid_mbox: garbage in file
Date: Thu, 04 May 2006 17:59:27 -0500
Message-ID: <1146783568.22932.105.camel@mulgrave.il.steeleye.com>
References: <445A4C8F.5030204@sw.ru>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:64456 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751513AbWEDW7c (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 May 2006 18:59:32 -0400
In-Reply-To: <445A4C8F.5030204@sw.ru>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vasily Averin <vvs@sw.ru>
Cc: linux-scsi@vger.kernel.org, Neela.Kolli@engenio.com, Atul Mukker <Atul.Mukker@lsil.com>, Seokmann.Ju@lsil.com, sreenib@lsil.com, devel@openvz.org

On Thu, 2006-05-04 at 22:48 +0400, Vasily Averin wrote:
> attempt to access beyond end of device
> sda6: rw=0, want=1044134458, limit=951401367
> Buffer I/O error on device sda6, logical block 522067228

That's not a SCSI error.  It's coming from the block layer and it means
that the filesystem tried to access beyond the end of the listed
partition.   Why that happened is anyone's guess.  I suspect the actual
filesystem is corrupt somehow, but how it came to be, I don't know.

James


