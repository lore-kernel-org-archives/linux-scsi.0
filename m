From: "Martin Peschke3" <MPESCHKE@de.ibm.com>
Subject: Re: [PATCH] SCSI Core patches
Date: Wed, 15 Jan 2003 16:35:35 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OFD72246CF.E2385102-ONC1256CAF.0050D1E1@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: patmans@us.ibm.com
Cc: Luben Tuikov <luben@splentec.com>, linux-scsi@vger.kernel.org

Patrick,

> > I would like to come to an agreement that the method of scsilun_to_int
> > is wrong and that we have to care for 64 bit LUNs in the SCSI core,
> > i.e. store LUNs as they are provided by the REPORT_LUNs response and
> > passing them unchanged to HBA drivers.
>
> I agree with that, I'm not planning on creating a patch for it. Someone
> with the proper adapter and storage should probably work on a patch, and
> there is currently (AFAIK!) only one open source driver that can handle
an
> 8 byte lun :)

Ok, I've got it. I'll try to come up with a proposal and an appropriate
patch
as a base for further discussion. I have the hardware environment ready
at hand. But prior to testing such a patch, some more work needs to be
done in our HBA driver in order to heave it from 2.4 to 2.5.

If anybody on the list has objections against 64 bit LUNs, it is now time
to
speak out.


Martin Peschke

