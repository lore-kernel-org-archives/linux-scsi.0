From: "Bryan Henderson" <hbryan@us.ibm.com>
Subject: RE: [RFC] Persistent naming of scsi devices
Date: Fri, 12 Apr 2002 10:18:48 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OF9E2A7718.0FCC8C9D-ON87256B99.005E39A7@boulder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: berthiaume_wayne@emc.com
Cc: linux-scsi@vger.kernel.org


That clarifies things a bit.  Clariion uses an unfortunate terminology; we
have to keep that in mind in these naming discussions because, for example,
when we talk a about making a device file name out of host/bus/target/lun,
we're talking about a Clariion VLUN, not a Clariion LUN.  The Clariion LUN
is what I believe most others would call a "volume."  Or maybe a virtual
disk.

>The physical LUN itself is not a physical disk in the physical
>array but created at the time you bind disks or portions of disks into
LUN.

Don't you feel funny saying "physical LUN" (physical logical unit number)?
:-) Is it physical or logical?  And is it a number or a storage medium?


