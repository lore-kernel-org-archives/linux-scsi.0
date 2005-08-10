From: dth@picard.cistron.nl (Danny ter Haar)
Subject: Re: [GIT PATCH] final SCSI bug fixes before 2.6.13
Date: Wed, 10 Aug 2005 17:31:28 +0000 (UTC)
Message-ID: <ddddlg$v3v$1@news.cistron.nl>
References: <1123689057.5134.8.camel@mulgrave>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from uucp.cistron.nl ([62.216.30.38]:5279 "EHLO ncc1701.cistron.net")
	by vger.kernel.org with ESMTP id S965231AbVHJRbd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Aug 2005 13:31:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

James Bottomley  <James.Bottomley@SteelEye.com> wrote:
>This tree represents the final bug fixes, both for oopses seen by
>various people.  One is for the dual binding of the i2o drivers and the
>other is for an oops adding and removing devices from the lpfc and
>qlogic fibre drivers.
>
>The tree is at
>www.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

Is this patch allready included in the 2.6.13-rc6-git1 patch ?

I compiled/installed that kernel now over 6 hours ago

reboot   system boot  2.6.13-rc6-git1  Wed Aug 10 13:24          (06:04)

Prior to that 2.6.13-rc6 crashed on me twice:

reboot   system boot  2.6.13-rc6       Mon Aug  8 16:52 (1+20:29)
reboot   system boot  2.6.13-rc6       Sun Aug  7 22:07 (2+15:14)

Although it managed to receive 1.8 and sent 3.6TB in 24 hours!

Danny

