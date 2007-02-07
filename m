From: Bernardo Innocenti <bernie@develer.com>
Subject: Re: Writing performance problem with SAS1068
Date: Wed, 07 Feb 2007 21:57:02 +0100
Message-ID: <45CA3D1E.9030203@develer.com>
References: <45C84333.709@develer.com> <45C8D686.7010103@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 81-174-33-43.f5.ngi.it ([81.174.33.43]:34786 "EHLO develer.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1030640AbXBGU7I (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Feb 2007 15:59:08 -0500
In-Reply-To: <45C8D686.7010103@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: mpt_linux_developer@lsil.com, lkml <linux-kernel@vger.kernel.org>, Develer IT Infrastructure <it@lists.develer.com>, linux-scsi@vger.kernel.org

Douglas Gilbert wrote:

> You may like to check that Write Cache Enable is on with:
> 'sdparm --get=WCE /dev/sdd'.

Yeah, yeah!  Works fine once I toggled the WCE to 1.  Writing
flies at 70MB/s, which is extremely good for those desktop-grade
disks (Seagate Barracuda SATA 250GB @7200RPM).

Thank you very much!

But... who do you think I should bug to make this the system
default?  Does write caching need to be enabled by the driver
itself, in the SCSI layer or perhaps by the distro initscripts?

-- 
   // Bernardo Innocenti - Develer S.r.l., R&D dept.
 \X/  http://www.develer.com/
