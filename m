From: "Bryan Henderson" <hbryan@us.ibm.com>
Subject: Re: [Possibly OT] Re: /proc/scsi/map
Date: Tue, 18 Jun 2002 08:49:16 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OF23543BD5.0C1295FA-ON87256BDC.00569E7A@boulder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Austin Gonyou <austin@digitalroadkill.net>, Kurt Garloff <kurt@garloff.de>, Linux SCSI list <linux-scsi@vger.kernel.org>


>The simple fact of the matter is that to provide truly consistent,
>persistent device naming requires that the naming be "end-to-end".  You
>can not rely on *any* ordering issues (such as controllers, PCI busses,
>devices, etc), you have to read the name from the device itself and the
>name has to be totally irrespective of the devices current location on
>whatever bus it uses.

Plus, in a case like this, you don't want the name to change if you move
the data from one disk drive to another.  It's still the same volume, and
the volume is what you care about.

But we do have look out for other cases.  Like non-storage devices.



