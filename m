From: Nic Ferrier <nferrier@tapsellferrier.co.uk>
Subject: Re: aacraid died on kernel 2.4.27
Date: Fri, 11 Mar 2005 20:31:36 +0000
Message-ID: <87br9plyaf.fsf@tapsellferrier.co.uk>
References: <60807403EABEB443939A5A7AA8A7458BE5A9C9@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from owls-tree.tapsellferrier.co.uk ([80.168.156.78]:48544 "EHLO
	owls-tree.tapsellferrier.co.uk") by vger.kernel.org with ESMTP
	id S261771AbVCKUgx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Mar 2005 15:36:53 -0500
In-Reply-To: <60807403EABEB443939A5A7AA8A7458BE5A9C9@otce2k01.adaptec.com> (Mark
 Salyzyn's message of "Fri, 11 Mar 2005 11:06:47 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: linux-scsi@vger.kernel.org

"Salyzyn, Mark" <mark_salyzyn@adaptec.com> writes:

> This is a processor based RAID card, so stability and complexity is
> virtually all rooted in the card. The problems you are experiencing are
> most probably specific to your platform, and do not show up in other
> adapters and systems that communicate with this same driver. Although
> the driver can be used to mitigate some problems in the adapter
> Firmware, it can not solve Power Supply, Hardware, Internal Firmware
> Failures, Drive or Cabling issues. All these issues need to be resolved
> first by communicating with Dell Technical Support.
>
> Sadly, all these issues can end up locking up the card or the scsi bus.
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
