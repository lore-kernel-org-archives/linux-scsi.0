From: James Bottomley <James.Bottomley@steeleye.com>
Subject: RE: Recovered disk error caused disk to go offline.
Date: 01 Feb 2004 11:23:07 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1075652588.1756.18.camel@mulgrave>
References: <200402011610.i11GAXi12108@dns1.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:26531 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S265351AbUBAQXQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 1 Feb 2004 11:23:16 -0500
In-Reply-To: <200402011610.i11GAXi12108@dns1.watkins-home.com>
List-Id: linux-scsi@vger.kernel.org
To: Guy <bugzilla@watkins-home.com>
Cc: 'SCSI Mailing List' <linux-scsi@vger.kernel.org>

On Sun, 2004-02-01 at 11:10, Guy wrote:
> RedHat 9.0
> >From uname -a:
> Linux watkins 2.4.20-8smp #1 SMP Thu Mar 13 17:45:54 EST 2003 i686 i686 i386
> GNU/Linux

Aha, for a vendor kernel you need to file a bugzilla with redhat.

Alternatively, if you can reproduce it with the latest kernel.org 2.4 or
2.6 kernel, we can diagnose it.

James


