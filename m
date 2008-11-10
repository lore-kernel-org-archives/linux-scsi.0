From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: UNMAP is a hint
Date: Mon, 10 Nov 2008 12:56:14 -0500
Message-ID: <491875BE.9080702@redhat.com>
References: <4913028B.6010405@redhat.com> <1225984628.4703.80.camel@localhost.localdomain> <Pine.LNX.4.64.0811061519350.3431@Nokia-N800-26> <20081107120534.GO21867@kernel.dk> <1226072970.15281.46.camel@think.oraclecorp.com> <20081109233639.GT4985@disturbed> <9FA859626025B64FBC2AF149D97C944A8A648D@CORPUSMX80A.corp.emc.com> <20081110083126.GF2373@disturbed> <1226311189.4367.30.camel@macbook.infradead.org> <9FA859626025B64FBC2AF149D97C944A8A64A6@CORPUSMX80A.corp.emc.com> <20081110173002.GO15439@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20081110173002.GO15439@parisc-linux.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Black_David@emc.com, dwmw2@infradead.org, david@fromorbit.com, martin.petersen@oracle.com, chris.mason@oracle.com, jens.axboe@oracle.com, James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, coughlan@redhat.com
List-Id: linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> On Mon, Nov 10, 2008 at 12:05:57PM -0500, Black_David@emc.com wrote:
>   
>>> On Mon, 2008-11-10 at 19:31 +1100, Dave Chinner wrote:
>>>       
>>>> I think this is the crux of the issue. IMO, it's not much of a
>>>>         
>> standard
>>     
>>>> when the spirit of the standard is to allow everyone to implement
>>>> different, non-deterministic behaviour....
>>>>         
>>> I disagree. The discard request is a _hint_ from the upper layers, and
>>> the storage device can act on that hint as it sees fit. There's
>>>       
>> nothing
>>     
>>> wrong with that; it doesn't make it "not much of a standard".
>>>       
>> Bingo!  That is exactly the spirit and thinking behind the UNMAP
>> proposal.
>>     
>
> While that may be, it's hardly the spirit that Ric (at least) has been
> promoting with dire warnings about how 'Enterprise class' customers will
> react if Linux does the wrong thing for EMC arrays with discard/trim/unmap.
>
>   

It would be nice to have arrays that can handle an OS that gives it 
perfect information (as our current code should do) regardless of 
alignment and size of requests.

Would something else be good enough is a reasonable question, but I fear 
lots of disgruntled customers ;-)

ric

