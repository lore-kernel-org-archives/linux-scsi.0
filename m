From: Dan Williams <dan.j.williams@gmail.com>
Subject: Re: [RFC][PATCH linux-firmware] isci: Add firmware blob and sources
Date: Sun, 18 Dec 2011 10:59:50 -0800
Message-ID: <CAA9_cmd9KMS3UBsQJ0WxT0rtQJVWceVwxvyXtRD+PuzwjUHUGA@mail.gmail.com>
References: <1324142068.2825.341.camel@deadeye>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:36479 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981Ab1LRS7w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 18 Dec 2011 13:59:52 -0500
In-Reply-To: <1324142068.2825.341.camel@deadeye>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Intel SCU Linux support <intel-linux-scu@intel.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>

On Sat, Dec 17, 2011 at 9:14 AM, Ben Hutchings <ben@decadent.org.uk> wr=
ote:
> isci requires a parameter blob which is usually found in NVRAM, but i=
t
> can fall back to loading with request_firmware(). =A0These files are
> taken from the Linux source tree where they were wrongly added in
> Linux 3.0.

Oh, I was of the impression that the external firmware tree was for
license incompatible firmware images?

> ---
> I'm a bit unclear on the purpose and use of isci_firmware.bin. =A0Is =
it
> needed for production hardware?

It's a stop gap for platforms with missing or broken oem parameters.
It is meant to become vestigial once the platform revisions quiet
down.

> Does it need to be customised
> per-system, or are module parameters sufficient for that? =A0(If not,=
 why
> isn't it built into the driver?)

It is customized per system to meet EMI and signal integrity targets
of a given platform.

> probe_roms.h is labelled with a dual BSD/GPLv2 licence but the other
> files had no licence header so I've treated them as GPLv2 by default.

The latest version of probe_roms.h [1] supports the v1.3 oem parameter
format, this patch appears to be v1.0 based.

Regards,
Dan

[1]: http://git.kernel.org/?p=3Dlinux/kernel/git/djbw/isci.git;a=3Dblob=
;f=3Ddrivers/scsi/isci/probe_roms.h;hb=3Drefs/heads/fixes
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
