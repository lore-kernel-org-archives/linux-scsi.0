From: Bernd Schubert <bs@q-leap.de>
Subject: what is return code 70000
Date: Wed, 16 Jan 2008 19:13:24 +0100
Message-ID: <200801161913.24753.bs@q-leap.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.q-leap.de ([153.94.51.193]:35904 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751607AbYAPSN0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Jan 2008 13:13:26 -0500
Received: from lanczos (lanczos [192.168.55.86])
	by mail.q-leap.de (Postfix) with ESMTP id 2B47669FE
	for <linux-scsi@vger.kernel.org>; Wed, 16 Jan 2008 19:13:25 +0100 (CET)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I already grepped, but I don't find the definition of 

return code = 0x00070000


Just got with FC and 2.4.18 of scientitfic linux:

sd 1:0:0:0: SCSI error: return code = 0x00070000
end_request: I/O error, dev sdb, sector 294388752
device-mapper: multipath: Failing path 8:16.
sd 1:0:1:0: SCSI error: return code = 0x00070000
end_request: I/O error, dev sdc, sector 1713114128
device-mapper: multipath: Failing path 8:32.
sd 2:0:1:0: SCSI error: return code = 0x00070000
end_request: I/O error, dev sde, sector 2094272016
device-mapper: multipath: Failing path 8:64.


Since I have some error handling patches in queue for 2.6.22, I would like to 
know if I would have catched this error, but 0x00070000 is pretty meaningless 
for me :(


Thanks,
Bernd


-- 
Bernd Schubert
Q-Leap Networks GmbH
