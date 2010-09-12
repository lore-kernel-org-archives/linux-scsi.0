From: Michael Stroucken <mxs@cmu.edu>
Subject: Re: UltraStar fails detection with "Unsupported sector size 524"
Date: Sun, 12 Sep 2010 13:33:06 -0400
Message-ID: <4C8D0ED2.8080005@cmu.edu>
References: <19597.3653.893156.794645@pilspetsen.it.uu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tamade.ascient.net ([65.99.219.195]:60780 "EHLO
	tamade.ascient.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792Ab0ILRnD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Sep 2010 13:43:03 -0400
In-Reply-To: <19597.3653.893156.794645@pilspetsen.it.uu.se>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: linux-scsi@vger.kernel.org

Mikael Pettersson wrote:
> I got a bunch of 72G IBM UltraStars that were taken from some
> kind of IBM storage server.  The Linux kernel however doesn't
> like them, complaining about a non-512 byte sector size:
>
> According to the datasheets these drives have soft-configurable
> sector sizes from 512 up to 528 bytes, but they don't say how
> that configuration is done.
>
> Any ideas on how to reconfigure these drives for 512-byte sectors?
>   

Low level format?

Greetings,
Michael.
