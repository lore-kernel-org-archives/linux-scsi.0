From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: aacraid died on kernel 2.4.27
Date: Fri, 11 Mar 2005 15:54:29 -0500
Message-ID: <60807403EABEB443939A5A7AA8A7458BE5AAF7@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Received: from magic.adaptec.com ([216.52.22.17]:34268 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261367AbVCKUyn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Mar 2005 15:54:43 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nic Ferrier <nferrier@tapsellferrier.co.uk>
Cc: linux-scsi@vger.kernel.org

The I/O patterns are just not the same. Windoze typically can't even
approach more than 32 commands outstanding to the controller. And only
recently has the Cache bug been solved in the ROMB Firmware.

Sincerely -- Mark Salyzyn

-----Original Message-----
From: Nic Ferrier [mailto:nferrier@tapsellferrier.co.uk] 
Sent: Friday, March 11, 2005 3:32 PM
To: Salyzyn, Mark
Cc: linux-scsi@vger.kernel.org
Subject: Re: aacraid died on kernel 2.4.27

"Salyzyn, Mark" <mark_salyzyn@adaptec.com> writes:

> This is a processor based RAID card, so stability and complexity is
> virtually all rooted in the card. The problems you are experiencing
are
> most probably specific to your platform, and do not show up in other
> adapters and systems that communicate with this same driver. Although
> the driver can be used to mitigate some problems in the adapter
> Firmware, it can not solve Power Supply, Hardware, Internal Firmware
> Failures, Drive or Cabling issues. All these issues need to be
resolved
> first by communicating with Dell Technical Support.
>
> Sadly, all these issues can end up locking up the card or the scsi
bus.
> The end result being the scsi system timing out, taking the devices
> offline, then the file-system driver panicking. Similar symptoms, wide
> variety of causes.

The machine I am having trouble with has been running MS Windows for 2
years.

I just put linux on it (with no other changes) and we get regular
(twice daily) catastrophic crashes.

Can this be a controller problem? I'm not a hardware expert but it
doesn't sound like one to me.


Nic
