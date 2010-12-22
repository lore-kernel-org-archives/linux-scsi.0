From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: RFC: short reads on block devices
Date: Wed, 22 Dec 2010 13:08:53 -0500
Message-ID: <yq1mxnxznm2.fsf@sermon.lab.mkp.net>
References: <4D0B945C.2060309@interlog.com>
	<1292618194.2820.90.camel@mulgrave.site> <4D0F2524.5030407@suse.de>
	<1292860848.3034.6.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1292860848.3034.6.camel@mulgrave.site> (James Bottomley's
	message of "Mon, 20 Dec 2010 10:00:48 -0600")
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Hannes Reinecke <hare@suse.de>, dgilbert@interlog.com, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Penokie, George" <George.Penokie@lsi.com>
List-Id: linux-scsi@vger.kernel.org

>>>>> "James" == James Bottomley <James.Bottomley@suse.de> writes:

James> Well, T10 always gives the most conservative approach.  All other
James> array (and certainly all disk) vendors seem to confirm valid data
James> up to the error ... certainly for the DIF case, Martin secured
James> this agreement.

Well, secured is probably too strong a word. Nobody objected when it was
put in the DIX spec...

-- 
Martin K. Petersen	Oracle Linux Engineering
