From: A <ahmedcali@yahoo.com>
Subject: Question about SCSI Mid-Layer, getting list of scsi drives
Date: Fri, 18 Feb 2005 14:25:50 -0800 (PST)
Message-ID: <20050218222550.54304.qmail@web40422.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from web40422.mail.yahoo.com ([66.218.92.33]:4441 "HELO
	web40422.mail.yahoo.com") by vger.kernel.org with SMTP
	id S261536AbVBRWZv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Feb 2005 17:25:51 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

In kernel 2.4, I have a driver that interfaces to the
SCSI mid-layer using API - scsi_register_module. 
Through this API the (character) driver registers a
"struct scsi_Device_Template" that would contain
function pointers (specifically detect) that would be
called for each SCSI device in the system.  That way
my driver would have a knowledge and pointer to all
SCSI devices in the system.

I don't see the API - scsi_register_module in 2.6 (or
similar one) to which I an pass an object of the above
type.  Can someone please tell me how I can do the
same thing in 2.6.  I have looked into the function -
scsi_host_alloc(), but from my reading of code, I
don't think it does the same functionality as what I
was doing in 2.4.  Any pointer to any docs explaining
the changes from 2.4 to 2.6, or how to accomplish what
I am trying to do would be very appreciated.

Thank you,
A.



		
__________________________________ 
Do you Yahoo!? 
Yahoo! Mail - now with 250MB free storage. Learn more.
http://info.mail.yahoo.com/mail_250
