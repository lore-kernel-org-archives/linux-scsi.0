From: Theodore Tso <tytso@mit.edu>
Subject: Re: thin provisioned LUN support
Date: Fri, 7 Nov 2008 14:35:03 -0500
Message-ID: <20081107193503.GG29717@mit.edu>
References: <20081107120534.GO21867@kernel.dk> <1226072970.15281.46.camel@think.oraclecorp.com> <yq1r65na5ll.fsf@sermon.lab.mkp.net> <1226074002.8030.33.camel@localhost.localdomain> <1226074270.15281.50.camel@think.oraclecorp.com> <1226074710.8030.43.camel@localhost.localdomain> <1226078535.15281.63.camel@think.oraclecorp.com> <4914846C.5060103@redhat.com> <20081107183636.GB29717@mit.edu> <49148BDF.9050707@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <49148BDF.9050707@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Cc: Chris Mason <chris.mason@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <jens.axboe@oracle.com>, David Woodhouse <dwmw2@infradead.org>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, Black_David@emc.com, Tom Coughlan <coughlan@redhat.com>, Matthew Wilcox <matthew@wil.cx>
List-Id: linux-scsi@vger.kernel.org

On Fri, Nov 07, 2008 at 01:41:35PM -0500, Ric Wheeler wrote:
>> Will we be able to query the device and find out its TRIM/UNMAP
>> alignment requirements?  There is also a balanace between performance
>> (at least if the concern is sending too many separate TRIM commands)
>> and giving the SSD more flexibility in its wear-leveling allocation
>> decisions by sending TRIM commands sooner rather than later.
>>
>
> T10 is still working on the proposal for how to display unmap related  
> information for SCSI, so we don't even have a consistent way to find  
> this out today for this population.

Yeah, I know, the rhetorical question was mostly addressed at David
Black.  :-)

> Not sure what is possible for the ATA devices,

I thought ATA didn't have any TRIM alignment requirements, and it's
T10 that wants to add it to the SCSI side?

						- Ted
