From: Matthew Jacob <mjacob@feral.com>
Subject: Re: Warning - running *really* short on DMA buffers while doing file
 transfers
Date: Fri, 27 Sep 2002 05:18:26 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.BSF.4.21.0209270510350.20512-100000@beppo>
References: <20020927102503.GA15101@suse.de>
Reply-To: mjacob@feral.com
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20020927102503.GA15101@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: "Justin T. Gibbs" <gibbs@scsiguy.com>, "Pedro M. Rodrigues" <pmanuel@myrealbox.com>, Mathieu Chouquet-Stringer <mathieu@newview.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org


[ .. all sorts of nice discussion, but not on our argument point ]
> 
> Agrh. Who's saying 'fix' the hba driver? Either I'm not expressing
> myself very clearly, or you are simply not reading what I write.

I (foolishly) leapt in when you said "253 is 'over the top'". You seemed
to imply that the aic7xxx driver was at fault and should be limiting the
amount it is sending out. My (mostly) only beef with what you've written
is with that implication- mainly as "don't send so many damned commands
if you think they're too many". If the finger pointing at aic7xx is not
what you're implying, then this has been a waste of email bandwidth-
sorry.

-matt


