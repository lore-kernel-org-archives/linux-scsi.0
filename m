From: James.Smart@Emulex.Com
Subject: RE: [Announce] Emulex lpfcdriver v8.0.13 available
Date: Fri, 22 Oct 2004 06:17:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0B1E13B586976742A7599D71A6AC733C02F22C@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:5103 "EHLO emulex.emulex.com")
	by vger.kernel.org with ESMTP id S270994AbUJVKSB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Oct 2004 06:18:01 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: arjan@fenrus.demon.nl
Cc: linux-scsi@vger.kernel.org



> > - Of the six binary attributes that previously existed:
> 
> I assume you didn't add new ones either ?

Correct.


> > - Added ifdef's so the driver compiles/runs on:
> 
> sounds not the right approach; please submit a driver that has no
> version ifdefs; it's a *new* driver, compatibility ifdefs 
> make no sense
> at all.

For the version that we'll make the final acceptance call on - we'll remove these compatibility defines. However, in the mean time, we'll keep this approach so that a broader set of people can continue to run and exercise the driver.

-- James S
