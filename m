From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [PATCH] normalize fixed and descriptor sense data
Date: Fri, 27 Aug 2004 08:56:14 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DD91260-F839-11D8-A52F-00039398BB5E@ieee.org>
Mime-Version: 1.0 (Apple Message framework v619)
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:49880 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S265833AbUH0O4S
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Aug 2004 10:56:18 -0400
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi@vger.kernel.org

Doug G:

 > so deferred errors can
 > be ignored in many contexts

Any hope of Linux always reporting that deferred errors have occurred, 
at least via dmesg if not in a critical dialog?

A deferred error, in the context of sense data ((bytes[0] & x7F) != 
x70) is usually a purportedly rare and therefore interesting 
catastrophe of some kind, yes?  A failure to write seen while flushing 
cache.  A failure to eject after obediently faking "immediate"ly good 
status.  Etc.

 > http://marc.theaimsgroup.com/?l=linux-scsi&m=109359716220586

Sorry I failed to click thru to the context for this thread.

Pat LaVarre

