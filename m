From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: thin provisioned LUN support & file system allocation policy
Date: Fri, 07 Nov 2008 11:02:46 -0500
Message-ID: <491466A6.6020903@redhat.com>
References: <4913028B.6010405@redhat.com> <1225984628.4703.80.camel@localhost.localdomain> <Pine.LNX.4.64.0811061519350.3431@Nokia-N800-26> <20081107120534.GO21867@kernel.dk> <49143142.4010809@redhat.com> <20081107121934.GP21867@kernel.dk> <49145029.4040900@redhat.com> <20081107144311.GE9543@mit.edu> <4914568A.7090307@redhat.com> <49145E0C.4030705@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <49145E0C.4030705@hp.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: jim owens <jowens@hp.com>
Cc: Theodore Tso <tytso@mit.edu>, Jens Axboe <jens.axboe@oracle.com>, Chris Mason <chris.mason@oracle.com>, Dave Chinner <david@fromorbit.com>, David Woodhouse <dwmw2@infradead.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, Black_David@emc.com, "Martin K. Petersen" <martin.petersen@oracle.com>, Tom Coughlan <coughlan@redhat.com>, Matthew Wilcox <matthew@wil.cx>
List-Id: linux-scsi@vger.kernel.org

jim owens wrote:
> Ric Wheeler wrote:
>
>> The type of allocation that would help most is something that tries 
>> to keep the lower block ranges "hot" for allocation, second best 
>> policy would simply keep the allocated blocks in each block group hot 
>> and re-allocate them.
>
> This block reuse policy ignores the issue of wear leveling...
> as in most design things, trading one problem for another.
>
> jim

Wear levelling is not a problem for all (most?) T10 unmap capable arrays 
since they remap pretty much everything internally,

Ric

