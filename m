From: Joachim Geiler <Joachim.Geiler@t-online.de>
Subject: Re: cdrom_ioctl() hanging in 2.6.3
Date: Mon, 23 Feb 2004 06:47:04 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <c1c43f$pm4$1@sea.gmane.org>
References: <20040222134723.7de65a50.akpm@osdl.org>
Reply-To: Joachim.Geiler@t-online.de
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.224.249]:5557 "EHLO main.gmane.org")
	by vger.kernel.org with ESMTP id S261831AbUBWGAJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Feb 2004 01:00:09 -0500
Received: from root by main.gmane.org with local (Exim 3.35 #1 (Debian))
	id 1Av98Q-0003D5-00
	for <linux-scsi@vger.kernel.org>; Mon, 23 Feb 2004 07:00:06 +0100
Received: from p50912f78.dip.t-dialin.net ([80.145.47.120])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Mon Feb 23 06:00:06 2004
Received: from Joachim.Geiler by p50912f78.dip.t-dialin.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Mon Feb 23 06:00:06 2004
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Andrew Morton wrote:

> 
> Gents,
> 
> apparently KDE's `k3b' command is consistently hanging when accessing a
> SCSI CDROM.  See http://bugs.kde.org/show_bug.cgi?id=75553
> 
> Frank has generated a stack backtrace, below.
> 
> Is this an adaptec driver problem, or a generic thing?
> 
> Thanks.
Hello,

I have the same problems with k3b and a symbios scsi controller (sym53c875).
Hangs with 2.6.3rc3, 2.6.3mm1, 2.6.3mm2, but not with 2.6.1mm3 (tried only
these kernels).

Joachim
 

