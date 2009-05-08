From: Tejun Heo <tj@kernel.org>
Subject: Re: [GIT PATCH] block,scsi,ide: unify sector and data_len, take#2
Date: Fri, 08 May 2009 18:11:16 +0900
Message-ID: <4A03F734.2020000@kernel.org>
References: <1241423927-11871-1-git-send-email-tj@kernel.org>	<20090507192427K.fujita.tomonori@lab.ntt.co.jp> <20090508110630H.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20090508110630H.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-ide-owner@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, jeff@garzik.org, linux-ide@vger.kernel.org, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, bzolnier@gmail.com, petkovbb@googlemail.com, sshtylyov@ru.mvista.com, mike.miller@hp.com, Eric.Moore@lsi.com, stern@rowland.harvard.edu, zaitcev@redhat.com, Geert.Uytterhoeven@sonycom.com, sfr@canb.auug.org.au, grant.likely@secretlab.ca, paul.clements@steeleye.com, tim@cyberelk.net, jeremy@xensource.com, adrian@mcmen.demon.co.uk, oakad@yahoo.com, dwmw2@infradead.org, schwidefsky@de.ibm.com, ballabio_dario@emc.com, davem@davemloft.net, rusty@rustcorp.com.au, Markus.Lidel@shadowconnect.com, bharrosh@panasas.com
List-Id: linux-scsi@vger.kernel.org

Hello,

FUJITA Tomonori wrote:
> btw, you are still working on the cleanups of the block API, right?

The patchset I sent out today was the last large cleanup patchset I
had waiting.  I think I'm now ready to move onto adding new features.

> I also want to see some cleanups of request completion functions a bit
> (e.g. we don't need _bidi_ stuff, we have too many completion
> functions, etc...).

Hmmm... the bidi stuff not being used widely, I didn't pay too much
attention to it.  What do you have in mind?  Can you elaborate a bit?
We changed the API a lot anyway so if there's more to do doing it now
wouldn't be a bad idea.

Thanks.

-- 
tejun
