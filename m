From: Ben Collins <bcollins@debian.org>
Subject: SCSI add/remove device for 2.4
Date: Tue, 13 May 2003 20:49:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030514004910.GT433@phunnypharm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bristol.phunnypharm.org ([65.207.35.130]:35721 "EHLO
	bristol.phunnypharm.org") by vger.kernel.org with ESMTP
	id S261881AbTENBLk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 May 2003 21:11:40 -0400
Received: from hopper.phunnypharm.org ([65.207.35.143] ident=mail)
	by bristol.phunnypharm.org with esmtp (Exim 3.36 #1 (Debian))
	id 19Fl0K-0004Vp-00
	for <linux-scsi@vger.kernel.org>; Tue, 13 May 2003 21:24:24 -0400
Received: from bmc by hopper.phunnypharm.org with local (Exim 3.36 #1 (Debian))
	id 19FkSF-0005xz-00
	for <linux-scsi@vger.kernel.org>; Tue, 13 May 2003 20:49:11 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This may be beating a dead horse. I had heard this patch was rejected on
more than one occasion for Linux-2.4, but I'm here to pimp it again,
because ieee1394 disk insertion sucks without it.

Right now linux1394 requires rescan-scsi-bus.sh on linux-2.4 when an
SBP-2 (scsi) device is attached or removed. Yes, I know USB handles this
quite well, but that's only because USB does a scsi-host per device.
It's not uncommon for Firewire drives to be setup as high-volume raids
though (especially now that S800 is coming out), so this is really not
suitable for Firewire.

Problem is, there's no way to let the scsi layer know about add/remove
of devices other than rescan-scsi-bus.sh. Why not export that
functionality for things like sbp2? Yes, I know a well thought out and
defined hotplug setup could do the same thing, but that's not what I am
after.

Here's the patch, I'm hoping someone takes it and pushes it to Marcelo.

-- 
Debian     - http://www.debian.org/
Linux 1394 - http://www.linux1394.org/
Subversion - http://subversion.tigris.org/
Deqo       - http://www.deqo.com/
