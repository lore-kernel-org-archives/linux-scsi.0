From: "Brown, Len" <len.brown@intel.com>
Subject: RE: Linux 2.6.16-rc3
Date: Mon, 13 Feb 2006 03:02:46 -0500
Message-ID: <F7DC2337C7631D4386A2DF6E8FB22B30060BD1D9@hdsmsx401.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fmr18.intel.com ([134.134.136.17]:28820 "EHLO
	orsfmr003.jf.intel.com") by vger.kernel.org with ESMTP
	id S1751196AbWBMIFd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Feb 2006 03:05:33 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "David S. Miller" <davem@davemloft.net>
Cc: akpm@osdl.org, torvalds@osdl.org, linux-kernel@vger.kernel.org, axboe@suse.de, James.Bottomley@steeleye.com, greg@kroah.com, linux-acpi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, "Yu, Luming" <luming.yu@intel.com>, lk@bencastricum.nl, sanjoy@mrao.cam.ac.uk, helgehaf@aitel.hist.no, fluido@fluido.as, gbruchhaeuser@gmx.de, Nicolas.Mailhot@LaPoste.net, perex@suse.cz, tiwai@suse.de, patrizio.bassi@gmail.com, bni.swe@gmail.com, arvidjaar@mail.ru, p_christ@hol.gr, ghrt@dial.kappa.ro, jinhong.hu@gmail.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, bcrl@kvack.org

>> >- In http://bugzilla.kernel.org/show_bug.cgi?id=5989, Sanjoy 
>> >Mahajan has  another regression, but he's off collecting more info.
>> 
>> We're talking here about a system from 1999 where Windows 98
>> refuses to run in ACPI mode and instead runs in APM mode.
>
>If it worked before a change which was installed, it's a regression
>regardless of whether another OS tries to use ACPI on that system or
>not.  I don't understand how one can use that fact to label this as
>not a regression from Linux's perspective.

I don't think anybody claimed this isn't a regression for the 600X.
Sanjoy has done a wonderful job documenting that.

My point is that it that on the grand scale of bugs serious enough
to have an effect on the course of 2.6.16, this one doesn't qualify
unless the same issue is seen on other systems.

-Len
