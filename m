From: Bryan Henderson <hbryan@us.ibm.com>
Subject: Re: [Question] Does the kernel ignore errors writng to disk?
Date: Thu, 28 Apr 2005 16:14:59 -0700
Message-ID: <OFDAC458FF.56F50513-ON88256FF1.007F29BD-88256FF1.007FD60F@us.ibm.com>
References: <1114728218.18355.245.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:6791 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S262311AbVD1XPf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Apr 2005 19:15:35 -0400
In-Reply-To: <1114728218.18355.245.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: brace@hp.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, mike.miller@hp.com

>O_SYNC doesn't work completely on several file systems and only on the
>latest kernels with some of the common ones.

Hmmm.  You didn't mention such a restriction when you suggested fsync() 
before.  Does fsync() work completely on these kernels where O_SYNC 
doesn't?  Considering that a simple implementation of O_SYNC just does the 
equivalent of an fsync() inside every write(), that would be hard to 
understand.

--
Bryan Henderson                          IBM Almaden Research Center
San Jose CA                              Filesystems

