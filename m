From: Matthew Tehonica <matt.tehonica@mac.com>
Subject: Where to get patches for mvsas bug?
Date: Fri, 11 Dec 2009 10:42:51 -0500
Message-ID: <140794921580727151477054071505012511769-Webmail@me.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from asmtpout013.mac.com ([17.148.16.88]:49152 "EHLO
	asmtpout013.mac.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822AbZLKQnR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Dec 2009 11:43:17 -0500
Received: from spool004.mac.com ([10.150.69.54])
 by asmtp013.mac.com (Sun Java(tm) System Messaging Server 6.3-8.01 (built Dec
 16 2008; 32bit)) with ESMTP id <0KUH00712VJZFB80@asmtp013.mac.com> for
 linux-scsi@vger.kernel.org; Fri, 11 Dec 2009 07:43:11 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-raid@vfer.kernel.org

Hi all,

I'm having an issue with my new SASLP-MV8 card where I'm getting the errors: drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5 and the drives are being dropped.  I know there are some patches to apply that seem to fix this since it hasn't made it to a new kernel yet but can someone tell me where to find these patches?  I have searched everywhere and can't seem to find them.

Thanks!
Matt
