From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: aic79xx noise on hot insert in 2.6.19.x and 2.6.20
Date: Wed, 07 Feb 2007 01:03:12 -0800
Message-ID: <45C995D0.70108@us.ibm.com>
References: <C33207EA-8376-4A2F-828C-23B00327C42D@gmail.com>
Reply-To: "Darrick J. Wong" <djwong@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:40515 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030597AbXBGJEB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Feb 2007 04:04:01 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l17940rg001551
	for <linux-scsi@vger.kernel.org>; Wed, 7 Feb 2007 04:04:00 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.2) with ESMTP id l1793E3G231982
	for <linux-scsi@vger.kernel.org>; Wed, 7 Feb 2007 04:03:14 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l1793DUN013849
	for <linux-scsi@vger.kernel.org>; Wed, 7 Feb 2007 04:03:14 -0500
In-Reply-To: <C33207EA-8376-4A2F-828C-23B00327C42D@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Rustad <mrustad@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Mark Rustad wrote:
> I have systems with Supermicro X6-class (Nocona/Lindenhurst)
> motherboards with Adaptec SCSI and SAFTE backplanes running software
> RAID-1 (md) on a pair of drives. When I hot-insert a drive, I get a lot
> of noise from the kernel apparently due to lack of handling something in
> the interrupt routine. So far, life seems to go on after the event, but
> not knowing anything about the internals of the driver, I am concerned
> enough to want to ask about it.

I see the noise too, though I don't know enough about aic79xx (and am
too busy with aic94xx) to do anything about it.  As far as I can tell,
the driver's just being a little trigger happy with the "DUMP CARD
STATE" routine.  But that's my totally unqualified opinion. :)

--D
