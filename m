From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [RFC] FC transport: Disable LUN scanning from low level driver
Date: Tue, 21 Aug 2007 09:03:17 -0400
Message-ID: <46CAE295.2050404@emulex.com>
References: <20070820112121.GA1487@schmichrtp.de.ibm.com> <46CA3ACB.7070708@emulex.com> <20070821123640.GA4821@schmichrtp.de.ibm.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:42118 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189AbXHUNDV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Aug 2007 09:03:21 -0400
In-Reply-To: <20070821123640.GA4821@schmichrtp.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christof Schmitt <christof.schmitt@de.ibm.com>
Cc: linux-scsi@vger.kernel.org


Nit (but preferred) : change "no_target_scan" to "disable_target_scan".
Otherwise, patch is good.

Christof Schmitt wrote:
> I attached a new patch that adds a flag to the fc template. So far, it
> is untested. What is the better approach? Avoid scanning with the flag
> being 1 or use the 1 to enable scaning and make this change in all FC
> drivers?

1 to disable. Avoid changing the drivers...

> We had the discussion about zfcp inventing LUNs in the past
> (http://www.spinics.net/lists/linux-scsi/msg17125.html).

Yep.  However, I don't agree with Hannes in this case.  Given that the
firmware is already doing funky things to share the real adapter, I
believe it (or the driver) should do the right thing in the LUN
presentation to keep the system happy. But - I guess that's something
for a different time.

-- james s

