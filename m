From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: aacraid died on kernel 2.4.27
Date: Fri, 11 Mar 2005 11:06:47 -0500
Message-ID: <60807403EABEB443939A5A7AA8A7458BE5A9C9@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Received: from magic.adaptec.com ([216.52.22.17]:18574 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261203AbVCKQGt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Mar 2005 11:06:49 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nic Ferrier <nferrier@tapsellferrier.co.uk>, linux-scsi@vger.kernel.org

This is a processor based RAID card, so stability and complexity is
virtually all rooted in the card. The problems you are experiencing are
most probably specific to your platform, and do not show up in other
adapters and systems that communicate with this same driver. Although
the driver can be used to mitigate some problems in the adapter
Firmware, it can not solve Power Supply, Hardware, Internal Firmware
Failures, Drive or Cabling issues. All these issues need to be resolved
first by communicating with Dell Technical Support.

Sadly, all these issues can end up locking up the card or the scsi bus.
The end result being the scsi system timing out, taking the devices
offline, then the file-system driver panicking. Similar symptoms, wide
variety of causes.

Sincerely -- Mark Salyzyn

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Nic Ferrier
Sent: Thursday, March 10, 2005 4:02 PM
To: linux-scsi@vger.kernel.org
Subject: aacraid died on kernel 2.4.27

I've been trying, without success, to get the aacraid driver to work
reliably on a Dell 2650 Poweredge.

I'm using Debian so I tried kernel 2.6.8 first (Debian has it packaged
nicely but from a SCSI driver point of view it's just a standard
kernel.org source).

2.6.8 worked... but died as soon as we put the server under load.

2.6.11 also died under load.

Yesterday I put 2.4.27 on the box because I had understood that the
aacraid is stable in that release of the kernel. But a few hours ago
the box died in exactly the same way (it was under quite heavy load).

Unfortunately, I can't give you error messages because I don't have
any log from the failures. It comes out on the console and I don't
have it saved anywhere. But it definitely is the raid controller.


Maybe someone can answer the following for me:

- is the driver understood to be stable in 2.4.27?

- is there another driver I could try (would the pre-Cox one work?)

- is there anything I can do to alleviate the problem?




Nic Ferrier
http://www.tapsellferrier.co.uk
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
