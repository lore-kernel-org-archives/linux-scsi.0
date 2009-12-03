From: =?ISO-8859-1?Q?Kristleifur_Da=F0ason?= <kristleifur@gmail.com>
Subject: Re: 2.6.31-rc9 kernel BUG and mvsas
Date: Thu, 3 Dec 2009 21:36:24 +0000
Message-ID: <73e903670912031336n749c0bb4l5f2e46d5347e5875@mail.gmail.com>
References: <200909090414.41274.tfjellstrom@shaw.ca> <200909091030.13147.tfjellstrom@shaw.ca>
	<4AA7F965.6020408@garzik.org> <4AF0CFE1.8050407@tomt.net>
	<alpine.DEB.1.10.0912032214040.23464@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.25]:7027 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109AbZLCVgi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Dec 2009 16:36:38 -0500
In-Reply-To: <alpine.DEB.1.10.0912032214040.23464@uplift.swm.pp.se>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, Linux IDE mailing list <linux-ide@vger.kernel.org>

On Thu, Dec 3, 2009 at 9:17 PM, Mikael Abrahamsson <swmike@swm.pp.se> wrote:
>
> On Wed, 4 Nov 2009, Andre Tomt wrote:
>
>> Identical issues with the AOC-SASLP-MV8 card with 8 Seagate Barracuda
>> 7200.11 1.5TB drives using the mvsas driver. Creating a md raid array seems
>> to trigger it nearly instantly, however other loads do not trigger it
>> as fast (if at all, only tested briefly with paralell dd).
>
> Would just like to chime in with a "me too" on this. I've tried both ubuntu
> 9.10 kernel (2.6.31) and their 10.04 pre-alpha (guess it's 2.6.32-rc8) and
> mvsas + AOC-SASLP-MV8 is pretty much unusable. If I start md creation it
> stalls immediately and gets nowhere, last time I tried it md claimed it had
> written 160 blocks then it stalled (all drive LEDs on the controller is
> constantly lit).
>
> If I boot without drives and then hot-plug the drives, it immediately
> oops:es.
>
> Any code/fixes I can try, this is a lab machine so I can easily do whatever
> needed with it...
>

Hi,

I had a bit of trouble finding some patches that were released by Andy Yan at
Marvell on November 9th, so here is a link:

1/7: http://kerneltrap.org/mailarchive/linux-scsi/2009/11/9/6558753
2/7: http://kerneltrap.org/mailarchive/linux-scsi/2009/11/9/6558763
3/7: http://kerneltrap.org/mailarchive/linux-scsi/2009/11/9/6558773
4/7: http://kerneltrap.org/mailarchive/linux-scsi/2009/11/9/6558783
5/7: http://kerneltrap.org/mailarchive/linux-scsi/2009/11/9/6558793
6/7: http://kerneltrap.org/mailarchive/linux-scsi/2009/11/9/6558803
7/7: http://kerneltrap.org/mailarchive/linux-scsi/2009/11/9/6558813

I haven't tried these myself, but I believe that mr. Fjellstrom tried, with
success.

Note to the lists - the patches weren't properly construction for inclusion in
the kernel. If the outstanding issues could be fixed, this would be a boon to
the open-soure community as these cards are very good value for money. They
have been recommended for use on OpenSolaris by one of Stanford's ZFS
admins, which indicates their quality to be very much acceptable.

-- Kristleifur
