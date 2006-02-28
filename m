From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: scsi-misc-2.6 git tree...
Date: Tue, 28 Feb 2006 08:16:34 -0800
Message-ID: <20060228161634.GA3502@andrew-vasquezs-powerbook-g4-15.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:32274 "EHLO avexch02.qlogic.com")
	by vger.kernel.org with ESMTP id S1751848AbWB1QQh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Feb 2006 11:16:37 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@steeleye.com>
Cc: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

I've been hitting the following warning when attempting to fetch the
latest commits against the scsi-misc-2.6 tree:

	* refs/heads/smisc: does not fast forward to branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6; not updating.

I ended up just forcing an update with a '+' in my remotes file.
Moving forward should I just keep the 'force' udpate setting for
smisc-2.6 (similar to scsi-rc-fixes-2.6) -- a bit problematic, but
workable...

Thanks,
av
