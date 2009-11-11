From: Lukas Kolbe <lkolbe@TechFak.Uni-Bielefeld.DE>
Subject: Bug 14579 -  Devices disappear... and Bug 14577 - Data corruption
	with Adaptec
Date: Wed, 11 Nov 2009 17:02:20 +0100
Message-ID: <20091111160220.GC5705@TechFak.Uni-Bielefeld.DE>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smarthost.TechFak.Uni-Bielefeld.DE ([129.70.137.17]:41366 "EHLO
	smarthost.TechFak.Uni-Bielefeld.DE" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750918AbZKKQKP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Nov 2009 11:10:15 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: sfrey@techfak.uni-bielefeld.de

Hi all,

we'd really appreciate any hints and help we can get for the following
bugs:
http://bugzilla.kernel.org/show_bug.cgi?id=14579

In anticipation that we would be asked to run a current kernel snapshot,
we tested 2.6.32-rc2 and hit another bug:
http://bugzilla.kernel.org/show_bug.cgi?id=14577

I do not believe it's a hardware fault at the moment as the machine
ran OK under Solaris for a few weeks (including successful btape runs).

We'll happily provide more info if it's needed.

-- 
Regards,
Lukas Kolbe

