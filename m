From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH UPDATED] block: In blk_execute_rq_nowait, init rq->end_io
 before checking for dead queue.
Date: Thu, 21 Jun 2012 05:40:33 +0000
Message-ID: <4FE2B3D1.6070504@acm.org>
References: <CAFR8uecFzcrAYSy2ieJM5vWjNLSO3bjg20cy+B4cimHZ4RLktA@mail.gmail.com> <4FD345DC.6020405@acm.org> <CAFR8ueca-MQWRipE+3OQSpqmJ40HKJEY7jWt6PQ+zTCQ9Bh=5Q@mail.gmail.com> <4FD4DC26.5080902@acm.org> <CAFR8uecF0LwbV8FvYob5m34sVbKqafrNoYOrcRUQCEOymGnYRA@mail.gmail.com> <CAFR8uefK+nByiJ8tw5_KF1qEJs4du2mDdU36gg1_2nRNZXN5Fw@mail.gmail.com> <20120618224253.GH32733@google.com> <4FE21C15.6040409@acm.org> <CAFR8ueeFcnMCqG=A1im09crBNckgfPixsCz9oceQCpPeJ3wiNw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAFR8ueeFcnMCqG=A1im09crBNckgfPixsCz9oceQCpPeJ3wiNw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Muthu Kumar <muthu.lkml@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>, Jej B <James.Bottomley@hansenpartnership.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 06/21/12 00:53, Muthu Kumar wrote:

> Hmm... Shouldn't this be:
> 
> Signed-off-by: Muthukumar Ratty <muthur@gmail.com>
> Tested-by: Bart Van Assche <bvanassche@acm.org>


I'll modify that part of the patch if you prefer to be mentioned as the
author. I hadn't done that because you hadn't posted the patch in its
entirety yet.

 
> This part already went in, its here only for testing - So in the final
> patch, before applying this should be removed.


When did it go in ? As far as I can see that patch is not yet present in
Linus' tree nor in James' tree.

Bart.
