From: rct@gherkin.frus.com (Bob Tracy)
Subject: scsi_host_next_hn usage violates principle of least astonishment
Date: Thu, 8 Apr 2004 16:55:34 -0500 (CDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040408215534.7A564DBE6@gherkin.frus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gherkin.frus.com ([192.158.254.49]:54183 "EHLO gherkin.frus.com")
	by vger.kernel.org with ESMTP id S262079AbUDHVzf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Apr 2004 17:55:35 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@SteelEye.com

James et. al.,

Please confirm the validity of the following observation for a 2.6.4
kernel...  Each time I remove, then insert a PCMCIA SCSI adapter, the
number increases, i.e., first insertion is "scsi0", next time it's
"scsi1", and so forth.  The 2.4 behavior is what I would expect: each
time the adapter is inserted, it is assigned the name number.

Got more work than expected getting the sym53c500_cs driver ready for
2.6 :-(.  The biggest problem is a curious mixture of "passive" vs.
"hotplug" initialization code in the drivers available for use as models.

-- 
-----------------------------------------------------------------------
Bob Tracy                   WTO + WIPO = DMCA? http://www.anti-dmca.org
rct@frus.com
-----------------------------------------------------------------------
