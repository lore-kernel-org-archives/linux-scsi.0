From: Jeff Garzik <jeff@garzik.org>
Subject: Re: generating a Linux WWN?
Date: Thu, 27 Sep 2007 18:32:15 -0400
Message-ID: <46FC2F6F.3020009@garzik.org>
References: <46FB8024.8040807@garzik.org> <46FBB86B.8000206@emulex.com> <46FBBBEB.4020605@garzik.org> <46FBBE52.1080507@sgi.com> <46FBCC89.2030702@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:58547 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755732AbXI0WcU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Sep 2007 18:32:20 -0400
In-Reply-To: <46FBCC89.2030702@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: Michael Reed <mdr@sgi.com>, James.Smart@Emulex.Com, linux-scsi <linux-scsi@vger.kernel.org>

Douglas Gilbert wrote:
> I have come across two types of problems:
>   a) the scsi_debug driver looks like one or more logical units
>      behind one or more dual ported SAS devices. All generated
>      SAS address (for target ports, target devices and lus)
>      should be distinct and preferably world wide unique.
>      [My scsi_ses driver has a similar problem.]
>   b) SAS HBAs that can run in target mode don't have enough
>      unique SAS addresses allocated. A SAS initiator (the HBA's
>      normal mode) only needs a couple a SAS addresses (e.g.
>      3: one for the 4 internal phys, another for the 4
>      external phys and 1 for the SAS initiator _device_
>      (but I have never seen that done properly)). When you turn
>      the SAS HBA around as a target (or initiator/target for
>      bonus points) then each logical unit connected to or
>      simulated by the SAS target needs a unique SAS address.
> 
> Years ago I asked for linux to get a IEEE OID. In the absence
> of that perhaps we should use 0xffffff. FreeBSD, OpenBSD etc
> face a similar problem.


In absence of a better solution, I would be quite happy to start a 
precedent of using a high identifier -- but not 0xffffff.

Maybe we could start using 0xFE for open source operating systems. 
FE-00-00 for Linux, FE-00-01 for OpenBSD, etc.

Once it catches on, assign IANA the task of managing the FE-XX-XX 
numberspace.  The IEEE yearly fee alone for an identifier makes it 
unrealistic for open source operating systems, otherwise.

	Jeff


