From: rct@gherkin.frus.com (Bob Tracy)
Subject: sym53c500_cs driver addition
Date: Thu, 1 Apr 2004 10:24:33 -0600 (CST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040401162433.2B2A4DBE4@gherkin.frus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gherkin.frus.com ([192.158.254.49]:47517 "EHLO gherkin.frus.com")
	by vger.kernel.org with ESMTP id S262956AbUDAQYe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Apr 2004 11:24:34 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The subject driver is currently an add-on for the pcmcia-cs package,
and is used by the New Media Bus Toaster PCMCIA SCSI adapter.  If the
driver is to be maintained for use in 2.6 and beyond, it needs to be
added to the kernel tree.  I've started updating the driver and was
wondering if anyone else was already working on it: I'd like to avoid
duplication of effort.

Brief history: I've been maintaining the driver somewhat sporadically
for the past few years, and feeding the updates back to David Hines.
Several unsuccessful attempts were made to contact the original author
(Tom Corner <tcorner@via.at>).

-- 
-----------------------------------------------------------------------
Bob Tracy                   WTO + WIPO = DMCA? http://www.anti-dmca.org
rct@frus.com
-----------------------------------------------------------------------
