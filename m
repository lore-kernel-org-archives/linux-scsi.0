From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: thin provisioned LUN support
Date: Fri, 07 Nov 2008 15:37:03 -0500
Message-ID: <4914A6EF.9040701@redhat.com>
References: <20081107120534.GO21867@kernel.dk>	<1226072970.15281.46.camel@think.oraclecorp.com>	<yq1r65na5ll.fsf@sermon.lab.mkp.net>	<1226074002.8030.33.camel@localhost.localdomain>	<1226074270.15281.50.camel@think.oraclecorp.com>	<1226074710.8030.43.camel@localhost.localdomain>	<1226078535.15281.63.camel@think.oraclecorp.com>	<4914846C.5060103@redhat.com> <20081107183636.GB29717@mit.edu>	<49148BDF.9050707@redhat.com> <20081107193503.GG29717@mit.edu> <yq1iqqz9uqt.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <yq1iqqz9uqt.fsf@sermon.lab.mkp.net>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Theodore Tso <tytso@mit.edu>, Ric Wheeler <rwheeler@redhat.com>, Chris Mason <chris.mason@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Jens Axboe <jens.axboe@oracle.com>, David Woodhouse <dwmw2@infradead.org>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, Black_David@emc.com, Tom Coughlan <coughlan@redhat.com>, Matthew Wilcox <matthew@wil.cx>
List-Id: linux-scsi@vger.kernel.org

Martin K. Petersen wrote:
>>>>>> "Ted" == Theodore Tso <tytso@mit.edu> writes:
>>>>>>             
>
> Ted> I thought ATA didn't have any TRIM alignment requirements, and
> Ted> it's T10 that wants to add it to the SCSI side?
>
> The current UNMAP proposal in SCSI doesn't have requirements either.
>   

I think that is being actively debated & due to go out in the next 
update. Not sure that it will matter much since vendors will not have 
implemented it yet in their boxes (at least, not yet)....

ric


> Array vendors, suddenly realizing all the work they have to do to
> support this, are now talking about imposing additional constraints
> (orthogonal to the UNMAP command set) because of limitations in their
> existing firmware architectures.
>
> It obviously much easier for the array vendors to export a Somebody
> Elses Problem VPD page containing a constant than it is to fix
> inherent limitations in their internal architecture.
>
> We're trying to point out that that's an unacceptable cop out for
> something that's clearly their problem to deal with.
>
> My concern is that if we start doing the array people's homework at
> the OS level they won't be inclined to fix their broken firmware
> design.  Ever.
>
>   

