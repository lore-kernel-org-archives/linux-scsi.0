From: Pete <pwkpete@yahoo.com>
Subject: Re: [example PATCH - not for applying] exclude certain commands
Date: Thu, 24 Apr 2003 08:56:29 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030424155629.15803.qmail@web9902.mail.yahoo.com>
References: <UTC200304241521.h3OFL7e14246.aeb@smtp.cwi.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web9902.mail.yahoo.com ([216.136.129.37]:41990 "HELO
	web9902.mail.yahoo.com") by vger.kernel.org with SMTP
	id S263764AbTDXPoU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Apr 2003 11:44:20 -0400
In-Reply-To: <UTC200304241521.h3OFL7e14246.aeb@smtp.cwi.nl>
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com, stern@rowland.harvard.edu
Cc: Andries.Brouwer@cwi.nl, afafc@rnl.ist.utl.pt, greg@kroah.com, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, mike@hingston.demon.co.uk, pwkpete@yahoo.com, stelian@popies.net

Andries,

> [In other words, afafc@rnl.ist.utl.pt, mike@hingston.demon.co.uk,
> pwkpete@yahoo.com, stelian@popies.net: did you compare 2.5.68
> without and with this "if (len < 8) len = 8" patch?]
> 

The failures I was seeing was with 2.5.68, after adding your patch the error
went away, but never tried the .67 kernel. I still have the entire kernel error
log of the failure case if that is of interest.

Regards,

-Pete

__________________________________________________
Do you Yahoo!?
The New Yahoo! Search - Faster. Easier. Bingo
http://search.yahoo.com
