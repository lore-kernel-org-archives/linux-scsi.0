From: maximilian attems <max@stro.at>
Subject: mpt boot trouble 2.6.21, 2.6.22-rcX regression
Date: Tue, 3 Jul 2007 17:12:44 +0200
Message-ID: <20070703151244.GA6981@baikonur.stro.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from baikonur.stro.at ([213.239.196.228]:1083 "EHLO baikonur.stro.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758462AbXGCPMA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Jul 2007 11:12:00 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric.Moore@lsi.com, linux-scsi@vger.kernel.org
Cc: Frans Pop <elendil@planet.nl>, Olaf van der Spek <Olaf@xwis.net>

forwarding latest message to this boot trouble report
http://bugs.debian.org/425851

----- Forwarded message from Frans Pop <elendil@planet.nl> -----
Subject: Bug#425851: Processed: (no subject)
From: Frans Pop <elendil@planet.nl>
To: 425851@bugs.debian.org
Date: Tue, 3 Jul 2007 16:29:24 +0200
Cc: Olaf van der Spek <Olaf@xwis.net>

tags 425851 + upstream d-i
forwarded 425851 http://bugzilla.kernel.org/show_bug.cgi?id=8710
thanks

On Tuesday 03 July 2007 12:34, Olaf van der Spek wrote:
> I've installed 2.6.21 on two different VMware Workstation guests
> running on two different hosts and both fail to boot.

I've seen the same issue while installing D-I in vmware.

I've just run a git bisect and identified the commit that caused the 
regression. I've also verified that 2.6.22-rc7 has the same issue.

See the upstream BR for details.

Cheers,
FJP

----- End forwarded message -----
