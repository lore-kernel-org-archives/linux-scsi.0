From: Marc Bevand <bevand_m@epita.fr>
Subject: Re: cp from SATA to SCSI freeze
Date: Sun, 24 Oct 2004 11:02:41 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <clg24h$ep$1@sea.gmane.org>
References: <1098612795.11032.20.camel@tycho.astronomy.dk>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:46509 "EHLO main.gmane.org")
	by vger.kernel.org with ESMTP id S261437AbUJXLCp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 Oct 2004 07:02:45 -0400
Received: from list by main.gmane.org with local (Exim 3.35 #1 (Debian))
	id 1CLg96-0003me-00
	for <linux-scsi@vger.kernel.org>; Sun, 24 Oct 2004 13:02:44 +0200
Received: from ivry-1-81-57-179-18.fbx.proxad.net ([81.57.179.18])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Sun, 24 Oct 2004 13:02:44 +0200
Received: from bevand_m by ivry-1-81-57-179-18.fbx.proxad.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Sun, 24 Oct 2004 13:02:44 +0200
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On 2004-10-24, Bjarne Thomsen <bjarne.thomsen@get2net.dk> wrote:
|  [...]
|  Is there something that I can to to locate the
|  problem?

When it freezes, do you see some kernel messages displayed on
the console ?

Also, how many SATA disks and how many SCSI disks are involved ?
Are you using software RAID ?

-- 
Marc Bevand                          http://www.epita.fr/~bevand_m
Computer Science School EPITA - System, Network and Security Dept.

