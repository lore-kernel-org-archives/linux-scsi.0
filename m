From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: sg utils sg_io -i 0x24 -y "12 00:00:00 24 00"
Date: Thu, 27 Nov 2003 10:15:28 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4C806550-20FD-11D8-B3BD-0050E416C45B@ieee.org>
Mime-Version: 1.0 (Apple Message framework v552)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rly-ip04.mx.aol.com ([64.12.138.8]:7906 "EHLO
	rly-ip04.mx.aol.com") by vger.kernel.org with ESMTP id S264560AbTK0RS6
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Nov 2003 12:18:58 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

 > ftp://members.aol.com/plscsi/linux/plscsi.tar.gz
 > http://members.aol.com/plscsi/linux/plscsi.tar.gz
 > ...
 > Neither, whoops, yet give us ...
 > - O_RDWR
 > + O_RDONLY|O_NONBLOCK
 > ... SG_IO ... ioctl ...

Fixed.

However, I dreamed up this patch only by guessing from hints found on 
the web, not from reading a document anywhere.  At first glance 
O_RDONLY | O_NONBLOCK works better than O_RDWR.  No disk required, no 
disk spin up implied, even when the name is /dev/hd$v or /dev/scd$v$n 
rather than /dev/sg$n.   But as yet I'm none too sure what this change 
actually means.

Pat LaVarre

