From: Bernd Schubert <bs@q-leap.de>
Subject: [PATCH 0/5 v2] scsi error handler improvements
Date: Fri, 6 Feb 2009 01:00:14 +0100
Message-ID: <200902060100.15104.bs@q-leap.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns2.q-leap.de ([88.79.172.217]:33364 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753857AbZBFAAR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Feb 2009 19:00:17 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>

Hello,

over the last year we had an endless number of issues with hard raid units 
from various vendors. Due this we also have been running into problems with 
the scsi error handler. 

This is just as before, but without the first two patches ("print eh 
activation" and "Allow requeuement on DID_SOFT_ERROR").


Thanks,
Bernd

-- 
Bernd Schubert
Q-Leap Networks GmbH
