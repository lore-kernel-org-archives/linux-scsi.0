From: Luben Tuikov <luben@splentec.com>
Subject: Re: [PATCH] SCSI Core cmd allocation 3/3
Date: Mon, 13 Jan 2003 15:40:09 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E232429.3090300@splentec.com>
References: <3E1A2140.3000408@splentec.com> <20030111180355.B2225@infradead.org> <3E22F369.5080209@splentec.com> <20030113175948.A27650@infradead.org> <3E2310A0.8080308@splentec.com> <20030113121129.A16510@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

Patrick Mansfield wrote:
> On Mon, Jan 13, 2003 at 02:16:48PM -0500, Luben Tuikov wrote:
> 
>>Christoph Hellwig wrote:
>>
>>>Well, where do you actually _need_ scsi_get_command(), that's the question.
>>>
>>>I see the purpose, but I don't see it actually used.
>>
>>The scsi devices discovery code *may* use it.
> 
> 
> Then do so in another patch.

You're talking to the wrong person.  Someone else is/was working on
the scsi discovery code.  Furthermore scsi discovery code will evolve
more, and eventually I see SCSI Core as a two-part subsystem:
scsi queuing (I'm trying to find out if it's worth it), and
scsi target discovering.  Scsi queuing will be quite tiny, and
scsi target discovering --- someone else will do.

> 
>>If a global variable is used in a couple of files, belonging
>>to the same functionality, providing a unified service, and if
>>there's more than one of them, then they are better organized
>>as such as I've outlined.
> 
> 
> Then move all the scsi globals into it. But, that should be a separate
> patch.

Right, it should be in a separate patch, but I did not want to do this job.

I just prompted the idea, and left it for the rest of the SCSI Core
developers to slowly (with each patch) move things therein.

> You should match the other kernel code as much as possible, it makes it
> easier for other kernel developers to read it.

Let's not make a career move out of 2 lines of code in an inline
function. It's not like my code uses GNU-style -- this is what you
make it sound like. Don't forget, it's just 2 lines and I was merely
trying to save macro space -- we don't need 100K line macro files.

Now let's get some work done.

-- 
Luben


