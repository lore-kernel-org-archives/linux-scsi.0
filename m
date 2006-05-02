From: Hannes Reinecke <hare@suse.de>
Subject: Re: request to add aic94xx to -mm
Date: Tue, 02 May 2006 09:10:33 +0200
Message-ID: <445705E9.3060603@suse.de>
References: <1146243246.5251.29.camel@mulgrave.il.steeleye.com> <20060428172736.GA11321@infradead.org> <20060428175521.GB18383@us.ibm.com> <20060428175914.GB18373@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41669 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S932424AbWEBHLA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 May 2006 03:11:00 -0400
In-Reply-To: <20060428175914.GB18373@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Tarte, Robert" <Robert_Tarte@adaptec.com>
Cc: Christoph Hellwig <hch@infradead.org>, Mike Anderson <andmike@us.ibm.com>, James Bottomley <James.Bottomley@SteelEye.com>, Andrew Morton <akpm@osdl.org>, linux-scsi <linux-scsi@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>

Christoph Hellwig wrote:
> On Fri, Apr 28, 2006 at 10:55:21AM -0700, Mike Anderson wrote:
>> I added Rob to this thread so he could comment on this.
>>
>> It would also be good before we put another card through this proces=
s that
>> at least a few distros have the request_firmware infrastructure full=
y
>> functional. I have seen indications that there where a few bumps in =
the
>> road in getting this working.
>=20
> at least suse has it working now after some initial problems.  let's =
hope
> the supposedly market leader doesn't fall behind their competition he=
re :)

Well, _I_ for one wouldn't mind :-)

Speaking of which:
Rob, Mike, there are some PCI IDs missing in the driver.
Please make sure all cards are really supported.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
