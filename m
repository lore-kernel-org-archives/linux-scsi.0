From: "Smart, James" <James.Smart@Emulex.com>
Subject: RE: Transport affected timeouts...
Date: Thu, 22 Apr 2004 17:36:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3356669BBE90C448AD4645C843E2BF2802C016E3@xbl.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:21652 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S264696AbUDVVhF
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Apr 2004 17:37:05 -0400
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <James.Bottomley@SteelEye.com>
Cc: 'Brian King' <brking@us.ibm.com>, Linux SCSI Reflector <linux-scsi@vger.kernel.org>



> I know the way solaris does this is to have a global variable that
> allows you to raise the timeout.  If we simply exposed 
> Brian's proposed
> parameter in sysfs, so you could change it from user space, would that
> be sufficient?


Yes.

-- James S
