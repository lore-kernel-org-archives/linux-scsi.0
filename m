From: "Bryan Henderson" <hbryan@us.ibm.com>
Subject: Re: Lun 0
Date: Mon, 21 Oct 2002 11:17:21 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OF3D6EEFA2.FF91CFF9-ON87256C59.005E879D@boulder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: MShetty <mranalini.shetty@patni.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>


>A piece of code I am reading sends the Inquiry cmd to lun 0 first and then
to
>the actual lun to be probed. As only SCSI devices have the concept of
luns... I
>think the 1st probe to lun 0 is to check if it is a SCSI device

That doesn't make much sense.  It's also true that only SCSI devices have
the concept of the SCSI Inquiry command.  There's no interface with which
you could send an Inquiry command to a device which is not in some way
SCSI.

But I can imagine using such a sequence to distinguish the absence of a
particular logical unit from the absence of the entire physical unit.  It
would be useful in problem diagnosis to know which of those is the case.




