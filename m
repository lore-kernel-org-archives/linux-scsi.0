From: Luben Tuikov <luben@splentec.com>
Subject: Re: [RFC][PATCH] scsi-misc-2.5 software enqueue when can_queue reached
Date: Mon, 03 Mar 2003 23:49:59 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E643077.100@splentec.com>
References: <20030228111924.A32018@beaverton.ibm.com>	<20030302085728.A11407@infradead.org>	<3E639C1E.7060000@splentec.com> <20030303171116.0ca432a0.akpm@digeo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20030303171116.0ca432a0.akpm@digeo.com>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@digeo.com>
Cc: hch@infradead.org, patmans@us.ibm.com, linux-scsi@vger.kernel.org

Andrew Morton wrote:
> Luben Tuikov <luben@splentec.com> wrote:
> 
>>>Linux codingstyle sais the && should be before the line break.
>>
>>Actually there's a point to this.
>>
> 
> 
> Sorry, but tough luck.

What do you mean?
 
> The advantages of everyone using the same coding style outweigh the arguable
> marginal benefits of introducing local inconsistencies.

I wasn't ``introducing local inconsistencies'', I was merely stating
a few facts.  And if you had quoted my whole letter you'd see that
I did not express personal opinion on the subject -- we already
have coding police. :-)
 
> I was a braces-on-a-new-line guy for nearly 20 years, but I knuckled under
> and learnt to use Linus-style for this reason.  I'm sure others can manage
> this.

After Pascal, I learned C from K&R1 over a decade ago.

In general I don't really care *that* much about the style
as long as it is K&R1 and the tabs are 8 spaces.  I care more
about the logistics in the code.

-- 
Luben


