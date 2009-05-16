From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 11/18] swim: dequeue in-flight request
Date: Sat, 16 May 2009 23:37:02 +0900
Message-ID: <4A0ECF8E.6000209@kernel.org>
References: <1241751256-17435-1-git-send-email-tj@kernel.org> <1241751256-17435-12-git-send-email-tj@kernel.org> <4A0EC2AD.20704@ru.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4A0EC2AD.20704@ru.mvista.com>
Sender: linux-ide-owner@vger.kernel.org
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, rusty@rustcorp.com.au, James.Bottomley@HansenPartnership.com, mike.miller@hp.com, donari75@gmail.com, paul.clements@steeleye.com, tim@cyberelk.net, Geert.Uytterhoeven@sonycom.com, davem@davemloft.net, Laurent@lvivier.info, jgarzik@pobox.com, jeremy@xensource.com, grant.likely@secretlab.ca, adrian@mcmen.demon.co.uk, sfr@canb.auug.org.au, bzolnier@gmail.com, petkovbb@googlemail.com, oakad@yahoo.com, drzeus@drzeus.cx, dwmw2@infradead.org, Markus.Lidel@shadowconnect.com, wein@de.ibm.com, schwidefsky@de.ibm.com, zaitcev@redhat.com, fujita.tomonori@lab.ntt.co.jp, axboe@kernel.dk
List-Id: linux-scsi@vger.kernel.org

Sergei Shtylyov wrote:
>   And without duplication:

Similar response as the if/else one on the other thread.  Is it really
any significantly better?  The 'duplication' here is basically one
liner after the peek/fetch change and when the duplication is minimal,
I usually find it clearer to put the loop condition at the while
clause itself.  If you think it's significantly better, please go
ahead and submit the patch but to me the change you're proposing is
basically cosmetic and not even a clearly better one at that.

Thanks.

-- 
tejun
