From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH 11/18] swim: dequeue in-flight request
Date: Sat, 16 May 2009 23:56:05 +0400
Message-ID: <4A0F1A55.8080701@ru.mvista.com>
References: <1241751256-17435-1-git-send-email-tj@kernel.org> <1241751256-17435-12-git-send-email-tj@kernel.org> <4A0EC2AD.20704@ru.mvista.com> <4A0ECF8E.6000209@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4A0ECF8E.6000209@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, rusty@rustcorp.com.au, James.Bottomley@HansenPartnership.com, mike.miller@hp.com, donari75@gmail.com, paul.clements@steeleye.com, tim@cyberelk.net, Geert.Uytterhoeven@sonycom.com, davem@davemloft.net, Laurent@lvivier.info, jgarzik@pobox.com, jeremy@xensource.com, grant.likely@secretlab.ca, adrian@mcmen.demon.co.uk, sfr@canb.auug.org.au, bzolnier@gmail.com, petkovbb@googlemail.com, oakad@yahoo.com, drzeus@drzeus.cx, dwmw2@infradead.org, Markus.Lidel@shadowconnect.com, wein@de.ibm.com, schwidefsky@de.ibm.com, zaitcev@redhat.com, fujita.tomonori@lab.ntt.co.jp, axboe@kernel.dk
List-Id: linux-scsi@vger.kernel.org

Hello.

Tejun Heo wrote:

>>   And without duplication:
>>     
>
> Similar response as the if/else one on the other thread.  Is it really
> any significantly better?  The 'duplication' here is basically one
> liner

   Not true, it's 3-liner. I wouldn't bother with one liner.

> after the peek/fetch change

   The peek/fetch code itself is duplicated. :-/

> and when the duplication is minimal,
> I usually find it clearer to put the loop condition at the while
> clause itself.

   No problem, we could just keep an old form of *while* loop.

> If you think it's significantly better,

   I do hink it avoids duplicating peek/fetch code.

> please go ahead and submit the patch but to me the change you're proposing is
> basically cosmetic and not even a clearly better one at that.
>   

   Should probably look at the resulting assembly to see how much it's 
differrent.

> Thanks.

WBR, Sergei


