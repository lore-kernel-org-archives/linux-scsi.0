From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: Aic7xxx 6.2.28 and Aic79xx 1.3.0 Released
Date: Thu, 23 Jan 2003 21:54:37 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <756820000.1043384077@aslan.scsiguy.com>
References: <694670000.1043380598@aslan.scsiguy.com>
 	<20030123.195327.107011605.davem@redhat.com>
 	<739810000.1043382396@aslan.scsiguy.com>
 <20030123.202727.102788332.davem@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20030123.202727.102788332.davem@redhat.com>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: "David S. Miller" <davem@redhat.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, torvalds@transmeta.com, alan@lxorguk.ukuu.org.uk, marcelo@conectiva.com.br

> And in fact, you are describing exactly what Linus and Marcelo's
> jobs are, to reject bogus/broken changes.

I think you missed the subtely of what I said.  It's not "their duty"
to never make a mistake, and it is not expected that they will catch
everything.  When they do miss something, or make a mistake you probably
tell them in a straight forward fashion.  In this case, what you
effectively said to me was:

	"Hey.  I would appreciate it if you would stop not
	 noticing this change that I made to your code through
	 Linus without telling you. *Twice* no less.  Wake up!
	 Wasn't it obvious?  It is *your duty* to notice these
	 one line changes that happen to break the build on
	 a platform that I care about but doesn't have any
	 consequences on the platforms you are probably testing.
	 Oh, and the aic79xx driver... well I didn't bother to
	 look at that because it's not in my configuration.
	 Oh well."

And I get all of this grief *after* I already included the change
instead of after the first time I missed it.  You really make me
laugh!

--
Justin

