From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: kexec and aacraid broken
Date: Thu, 31 May 2007 16:45:51 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF01A553B9@otce2k301.adaptec.com>
References: <86802c440705311259w4e96eafbs799251dd494e47a4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:40285 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752585AbXEaUpy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 May 2007 16:45:54 -0400
Content-class: urn:content-classes:message
In-reply-to: <86802c440705311259w4e96eafbs799251dd494e47a4@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Vivek Goyal <vgoyal@in.ibm.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

Ahhhh. explains why I am having troubles duping this issue thus far.

This is prerelease Firmware on a yet to be released card and thus should
not get any driver workarounds if this issue can be resolved in
Firmware. If this can be duped on a released card with released
Firmware, then the story changes of course; but still does not preclude
a Firmware/Hardware/Drive Compatibility bug ;-} . Until then, please
work this issue via SUN channels so that we get all the necessary card
debug information for our teams to work this.

I will ensure Adaptec will remain on top of this issue since it is
clearly a problem with the Adapter Hardware interfacing. The adapter is
not surviving an IOP_RESET and is going into an Adapter Firmware Kernel
Panic or taking an excessively long period (in the testing thus far >
540 seconds) of time to complete it's reset.

Sincerely -- Mark Salyzyn

Yinghai Lu [mailto:yhlu.kernel@gmail.com] sez:
> SUN coguar with 11731
> 
> On 5/31/07, Salyzyn, Mark <mark_salyzyn@adaptec.com> wrote:
> > > No, still get adapter kernel panic
> >
> > Which adapter are you using?
