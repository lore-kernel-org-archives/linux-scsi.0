From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [RFC] scsi host sysfs support again [0/4]
Date: Wed, 7 May 2003 18:44:51 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030508014451.GD7467@beaverton.ibm.com>
References: <20030505083315.GB8416@beaverton.ibm.com> <1052238508.1819.42.camel@mulgrave> <20030506172312.GA1697@beaverton.ibm.com> <20030507231953.GS524@linnie.riede.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:63203 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S264392AbTEHB3t
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 May 2003 21:29:49 -0400
Content-Disposition: inline
In-Reply-To: <20030507231953.GS524@linnie.riede.org>
List-Id: linux-scsi@vger.kernel.org
To: Willem Riede <wrlk@riede.org>
Cc: linux-scsi@vger.kernel.org

Willem Riede [wrlk@riede.org] wrote:
> On 2003.05.06 13:23 Mike Anderson wrote:
> > 
> > Other classes to consider:
> > 	(scsi_tape or tape), (scsi_disk or disk), (scsi_gen).
> > I believe Greg KH mentioned something to me about why we would select
> > scsi_tape over tape, but I have forgot the reason.
> > 
> Would that be, because ide_tape could have different attributes?
> 

I believe it is more of a late in the development cycle issue. There has
not been time applied to determining who would create the class and why
we would want a very generic class vs scsi_*. At least I have not seen
this information. Mochel or others may have better information. The new
class and class_device structure are fairly new so there is still some
conversion time to understand what to do and what not to do with them.

> In any case, there are some unique properties of onstream tapes that I
> would love to make available, so should osst define its own class?

If they are per driver attributes they should be exposed under
/sys/bus/scsi/drivers/osst. If they are per device attributes a class
may be the answer, but I have not thought about the upper level
attributes much yet. I did not think we would have classes at this
granularity, but maybe we do.

-andmike
--
Michael Anderson
andmike@us.ibm.com

