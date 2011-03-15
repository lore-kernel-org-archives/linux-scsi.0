From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [RFC PATCH 00/10] isci: core
Date: Tue, 15 Mar 2011 13:47:12 -0400
Message-ID: <4D7FA620.10004@garzik.org>
References: <20110310105347.6485.20780.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:63432 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757888Ab1CORrQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Mar 2011 13:47:16 -0400
Received: by qyk7 with SMTP id 7so2680537qyk.19
        for <linux-scsi@vger.kernel.org>; Tue, 15 Mar 2011 10:47:15 -0700 (PDT)
In-Reply-To: <20110310105347.6485.20780.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: james.bottomley@suse.de, dave.jiang@intel.com, linux-scsi@vger.kernel.org, jacek.danecki@intel.com, ed.ciechanowski@intel.com, jeffrey.d.skirvin@intel.com, edmund.nadolski@intel.com

On 03/10/2011 05:54 AM, Dan Williams wrote:
> The full driver and history is available in git:
>
>     git://git.kernel.org/pub/scm/linux/kernel/git/djbw/isci.git master
>
> The libsas-pending branch contains proposed libsas fixes (pending
> acceptance into scsi-misc):
>
>     git://git.kernel.org/pub/scm/linux/kernel/git/djbw/isci.git libsas-pending
>
> The x86-pending branch contains a proposed api for mapping bios roms so
> the driver can retrieve configuration parameters (pending acceptance
> into -tip):
>
>     git://git.kernel.org/pub/scm/linux/kernel/git/djbw/isci.git x86-pending
>
> --
> Dan for the isci driver team
>
>
> [1]: http://marc.info/?l=linux-scsi&m=129703780424729&w=2
>
> ---
>
> Dan Williams (10):
>        isci/core: controller
>        isci/core: phy
>        isci/core: port
>        isci/core: remote device
>        isci/core: remote node context
>        isci/core: stp
>        isci/core: request (general, ssp and smp)
>        isci/core: unsolicited frame handling and registers
>        isci/core: base state machine and memory descriptors
>        isci/core: common definitions and utility functions

Let's get this driver into staging for 2.6.39, if it isn't going to hit 
the merge window for 2.6.39.

It would lame for such [presumably] high volume hardware to be in 
neither the main kernel, nor staging, at 2.6.39 release time.

	Jeff



