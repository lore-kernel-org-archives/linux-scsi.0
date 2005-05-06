From: Bryan Henderson <hbryan@us.ibm.com>
Subject: Re: Empty partition nodes not created (was device node issues with recent
 mm's and udev)
Date: Fri, 6 May 2005 09:43:37 -0700
Message-ID: <OF36D48B29.45D85BB9-ON88256FF9.005B311E-88256FF9.005BEEB7@us.ibm.com>
References: <20050506080437.GE4604@pclin040.win.tue.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:54421 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261157AbVEFQnz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 May 2005 12:43:55 -0400
In-Reply-To: <20050506080437.GE4604@pclin040.win.tue.nl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andries Brouwer <aebr@win.tue.nl>
Cc: Andrew Morton <akpm@osdl.org>, Greg KH <greg@kroah.com>, Joe <joecool1029@gmail.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, "Randy.Dunlap" <rddunlap@osdl.org>

>There is a misunderstanding in terminology here.
>"DOS-type partition table" is for most Linux users the only type
>they have ever seen. The msdos in this context does not refer
>to a particular filesystem, like the fat or msdos filesystem.

As long as we're talking terminology: fat and msdos aren't particular 
filesystems.  They're particular filesystem types.  The contents of a 
particular DOS-fomatted floppy disk would be an example of a particular 
filesystem.

--
Bryan Henderson                          IBM Almaden Research Center
San Jose CA                              Filesystems
