From: Bernd Schubert <bs@q-leap.de>
Subject: [PATCH 0/2 (resend) ] fusion reset
Date: Wed, 7 Jan 2009 18:58:47 +0100
Message-ID: <200901071858.48672.bs@q-leap.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns2.q-leap.de ([88.79.172.217]:44667 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752983AbZAGR6u (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Jan 2009 12:58:50 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Sathya Prakash <Sathya.Prakash@lsi.com>, Eric Moore <Eric.Moore@lsi.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, DL-MPT Fusion Linux <DL-MPTFusionLinux@lsi.com>

Hello,

here are two patches for the mpt fusion reset handling. Still missing from the 
series is a patch to prevent DV deadlocks, since my present approach still 
sometimes leaves the deadlock.


-- 
Bernd Schubert
Q-Leap Networks GmbH
