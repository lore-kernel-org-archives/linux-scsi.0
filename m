From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: aacraid on Dell PE 2650
Date: Tue, 19 Oct 2004 09:48:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <60807403EABEB443939A5A7AA8A7458B40B1BF@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:44730 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S269403AbUJSNsI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Oct 2004 09:48:08 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Ryan Anderson <ryan@autoweb.net>, linux-scsi@vger.kernel.org
Cc: markh@osdl.org

Have you contacted Dell technical support?

The controller on the 2650 can suffer from problems resulting from a bad
power supply, pci transaction problems on the motherboard, scsi device
misbehavior locking the scsi bus, and (ghasp!) F/W bugs. Those issues
need to be investigated by the technical support cookbook.

As for the F/W, there are issues exasperate with increased horsepower on
the mainboard CPU, Hyperthreading, errant bus activity triggering an
adapter cache flush, etc. The problem with the adapter getting
constipated under these load conditions by a cache flush can be resolved
by turning the controller cache off. But this may be unnecessary if the
issue is rooted in the above hardware issues outlined above.

Sincerely -- Mark Salyzyn

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Ryan Anderson
Sent: Tuesday, October 19, 2004 9:30 AM
To: linux-scsi@vger.kernel.org
Cc: markh@osdl.org; AACRAID
Subject: aacraid on Dell PE 2650

I'm having some problems that I hope you can help with, or at least,
suggest a workaround that may make the problem go away.

I'm not on linux-scsi so please cc: me on all replies, please.

I've got a PowerEdge 2650 running the 2.6.8 kernel (source from the
Debian tree, I don't think there's anything substantial different
between it and 2.6.8.1 in this area.)

In short, I'm seeing a variety of drive related lockups.

The latest one referred to the drive being "offline" (I forgot to write
the exact error down, but I recall that word precisely)

None of the drives appear to be failed, as far as the controller is
concerned, and a simple reboot fixes the problem temporarily.

I'm seeing about a problem every 1.5 - 2 weeks at the moment, so it's a
bit hard to debug (and everytime it fails it creates a panic situation.)

It happened today for the 3rd time, all three have been while the
machine is under a decent amount of load.

Any assistance you can provide would be greatly appreciated.


-- 

Ryan Anderson                
AutoWeb Communications, Inc. 
email: ryan@autoweb.net 
