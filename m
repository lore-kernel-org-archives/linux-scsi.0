From: Markus Lidel <Markus.Lidel@shadowconnect.com>
Subject: Re: adaptec 2120S software under RedHat 8.0 and FC2
Date: Wed, 23 Mar 2005 18:43:31 +0100
Message-ID: <4241AAC3.7050702@shadowconnect.com>
References: <60807403EABEB443939A5A7AA8A7458BED3211@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Received: from s0003.shadowconnect.net ([213.239.201.226]:17034 "EHLO
	mail.shadowconnect.com") by vger.kernel.org with ESMTP
	id S261966AbVCWRmz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Mar 2005 12:42:55 -0500
In-Reply-To: <60807403EABEB443939A5A7AA8A7458BED3211@otce2k01.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ross Macintyre <raz@macs.hw.ac.uk>, Mark Haverkamp <markh@osdl.org>, linux-scsi <linux-scsi@vger.kernel.org>, matt_domsch@dell.com

Hello,

Salyzyn, Mark wrote:
 > [...]
>>note that if adaptec simply opensourced their managment tools we wouldn't
>>have this problem at all. I wonder why Adaptec did that for the old
>>i2o-based controllers but not aacraid.  
> Oh yes, that, worked hard on the powers-that-be to permit this. Could
> not release a substantial majority of it because it would violate
> licensed libraries (Zinc, being one of them, I am sorry to admit). So we
> release the engine and the raidutil. No logger, no remote communication
> engine, no GUI and no browser engine either. It was the best we could
> do.
> Once released, and under a BSD license, the open source community failed
> to contribute one change to the sources. All it did was permit the tools
> to be packaged, archived and to continue in-perpetuity when
> compatibility libraries failed to work on newer installations.

Hmmm, IMHO that's not 100% correct... It's true that currently there is 
no new version. I'm working on the 64-bit version and a rewrite of the 
kernel-interface to get rid of the ioctl's... Because i'm still working 
on the interface, i haven't released both the kernel as well as the 
raidutils yet. But you could look into subversion to see that there *is* 
developement. Also IMHO it is be better to provide documentation for how 
to program the controller instead of releasing the source of the 
management tool itself.

 > [...]



Best regards,


Markus Lidel
------------------------------------------
Markus Lidel (Senior IT Consultant)

Shadow Connect GmbH
Carl-Reisch-Weg 12
D-86381 Krumbach
Germany

Phone:  +49 82 82/99 51-0
Fax:    +49 82 82/99 51-11

E-Mail: Markus.Lidel@shadowconnect.com
URL:    http://www.shadowconnect.com
