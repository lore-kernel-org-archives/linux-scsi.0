From: "Parthiban  Manickam - NPD, Chennai" <pamanick@npd.hcltech.com>
Subject: RE: SCSI-ID persistence query...
Date: Thu, 13 May 2004 17:12:34 +0530
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <D8618A5F56A61941822B3F4B6FCA6D7908EC1E@npd-mail.hclt-ntl.co.in>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [202.54.64.17] ([202.54.64.17]:16911 "EHLO hclnpd.hcltech.com")
	by vger.kernel.org with ESMTP id S264119AbUEMLo3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 May 2004 07:44:29 -0400
List-Id: linux-scsi@vger.kernel.org
To: Shobhit Mathur <shobhitmmathur@yahoo.com>, linux-scsi@vger.kernel.org

Hi Shobhit

In case of Directed Attached Storage(DAS)
SCSI ID is configurable using jumper settings.
The vendor will provide the details about 
the configuration. You have to make sure that id
assigned is unique.

In the SAN(FC or iSCSI Based) environment initiator
will assign unique id.

thanks
Parthi

-----Original Message-----
From: Shobhit Mathur [mailto:shobhitmmathur@yahoo.com]
Sent: Thursday, May 13, 2004 4:30 PM
To: linux-scsi@vger.kernel.org
Subject: SCSI-ID persistence query...


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
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
