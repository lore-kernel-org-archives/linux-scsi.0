From: rct@gherkin.frus.com (Bob Tracy)
Subject: followup: sym53c500_cs driver addition
Date: Tue, 6 Apr 2004 15:40:50 -0500 (CDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040406204050.4DE26DBDB@gherkin.frus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gherkin.frus.com ([192.158.254.49]:47780 "EHLO gherkin.frus.com")
	by vger.kernel.org with ESMTP id S264000AbUDFUkv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Apr 2004 16:40:51 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Back on April 1st, I wondered "out loud" if anyone else might be working
on porting the sym53c500_cs driver to compile/work with the 2.6 kernel,
because I wanted to avoid duplication of effort.

As of this afternoon, I'm pleased to announce it's too late :-).  Haven't
actually tried I/O with an attached device, but the driver will at least
load and unload cleanly.  I'll submit the patch set for peer review in a
few days...  Lots of cleanup work left to do, not to mention testing the
basic functionality of the driver :-).

Anyone besides me have a circa 1996 New Media Bus Toaster PCMCIA SCSI
card that might be willing to assist with the testing?

-- 
-----------------------------------------------------------------------
Bob Tracy                   WTO + WIPO = DMCA? http://www.anti-dmca.org
rct@frus.com
-----------------------------------------------------------------------
