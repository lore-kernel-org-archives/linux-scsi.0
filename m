From: Shobhit Mathur <shobhitmmathur@yahoo.com>
Subject: SCSI-ID persistence query...
Date: Thu, 13 May 2004 04:00:21 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040513110021.36867.qmail@web51006.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web51006.mail.yahoo.com ([206.190.38.137]:51885 "HELO
	web51006.mail.yahoo.com") by vger.kernel.org with SMTP
	id S264093AbUEMLAX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 May 2004 07:00:23 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

I have a few basic questions pertaining to SCSI-id
numbering & persistence :

* How do SCSI targets/LUNs get numbered ? My view is
  that the OS numbers them as it receives
cmd-response.
* If the above observation is correct, a disk with a
  particular id during one boot, will not have the
same
  id during the next boot, which can have other 
  consequences...

  My question is: How is SCSI numbering done and how
is
  it persistent across boots ?

- Thank you

- Shobhit Mathur


	
		
__________________________________
Do you Yahoo!?
Yahoo! Movies - Buy advance tickets for 'Shrek 2'
http://movies.yahoo.com/showtimes/movie?mid=1808405861 
