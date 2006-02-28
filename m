From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: scsi-misc-2.6 git tree...
Date: Tue, 28 Feb 2006 11:25:24 -0600
Message-ID: <1141147524.3258.13.camel@mulgrave.il.steeleye.com>
References: <20060228161634.GA3502@andrew-vasquezs-powerbook-g4-15.local>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:31186 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932266AbWB1R01 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Feb 2006 12:26:27 -0500
In-Reply-To: <20060228161634.GA3502@andrew-vasquezs-powerbook-g4-15.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2006-02-28 at 08:16 -0800, Andrew Vasquez wrote:
> I've been hitting the following warning when attempting to fetch the
> latest commits against the scsi-misc-2.6 tree:
> 
> 	* refs/heads/smisc: does not fast forward to branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6; not updating.
> 
> I ended up just forcing an update with a '+' in my remotes file.
> Moving forward should I just keep the 'force' udpate setting for
> smisc-2.6 (similar to scsi-rc-fixes-2.6) -- a bit problematic, but
> workable...

This is probably my fault ... I've just rebuilt the scsi-misc tree to
transfer some patches to rc-fixes.  if you clone linux-2.6 at
v2.6.16-rc5 and then pull from the tree, it should just work (otherwise,
rsync will also follow as the tree goes backwards).

James


