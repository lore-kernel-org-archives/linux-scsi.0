From: Rik van Riel <riel@conectiva.com.br>
Subject: Re: Warning - running *really* short on DMA buffers while doing file
 transfers
Date: Fri, 27 Sep 2002 15:29:37 -0300 (BRT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L.0209271528540.22735-100000@imladris.surriel.com>
References: <2483176224.1033147178@aslan.btc.adaptec.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <2483176224.1033147178@aslan.btc.adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: Jens Axboe <axboe@suse.de>, Matthew Jacob <mjacob@feral.com>, "Pedro M. Rodrigues" <pmanuel@myrealbox.com>, Mathieu Chouquet-Stringer <mathieu@newview.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, 27 Sep 2002, Justin T. Gibbs wrote:

> FreeBSD has several algorithms in its VM to prevent a single process
> from holding onto too many dirty buffers.  FreeBSD, Solaris, True64,
> even WindowsNT have effective algorithms for sanely retiring dirty
> buffers without saturating the system.

I guess those must be bad for dbench, bonnie or other critical
server applications ;)

*runs like hell*

Rik
-- 
Bravely reimplemented by the knights who say "NIH".

http://www.surriel.com/		http://distro.conectiva.com/

Spamtraps of the month:  september@surriel.com trac@trac.org

