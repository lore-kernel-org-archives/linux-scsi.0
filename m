From: "Lee Xing" <lxing@Crossroads.com>
Subject: RE: Returned info from mid-level to low-level driver
Date: Mon, 10 May 2004 10:15:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <519672568F040C41B6FAC21ADF51B18FEFE7@mailnode1.commstor.crossroads.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email.crossroads.com ([65.68.235.6]:39600 "HELO
	email.crossroads.com") by vger.kernel.org with SMTP id S264737AbUEJPPi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 May 2004 11:15:38 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

Thanks for the info.  

I guess it probably won't be possible either for the low-level driver to specify which sdx/sgx special file to use for a registered disk.  Can some one confirm or correct this please?

Thanks,


Lee

-----Original Message-----
From: Christoph Hellwig [mailto:hch@infradead.org]
Sent: Friday, May 07, 2004 3:31 PM
To: Lee Xing
Cc: linux-scsi@vger.kernel.org
Subject: Re: Returned info from mid-level to low-level driver


On Fri, May 07, 2004 at 01:57:35PM -0500, Lee Xing wrote:
> After the low-level driver registers a physical disk into mid-level driver, which (with high-level driver) presents it as both sd and sg special files (say /sdb and /sgc) in user space, can low-level
driver know which sd/sg special files (for example, sda/sga or sdb/sgb, etc.) the disk is presented in user space?

No.

