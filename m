From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: Aic7xxx v6.2.22 and Aic79xx v1.3.0Alpha2 Released
Date: Tue, 10 Dec 2002 13:03:30 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <649720000.1039550610@aslan.btc.adaptec.com>
References: <200212101602.gBAG2Hi02930@localhost.localdomain>
Reply-To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <200212101602.gBAG2Hi02930@localhost.localdomain>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>, Marcelo Tosatti <marcelo@conectiva.com.br>, Linus Torvalds <torvalds@transmeta.com>

> The tarball contained a lot of extraneous files, but I think I got them
> all  weeded out.  I've but the result at:
> 
> http://linux-scsi.bkbits.net/scsi-aic7xxx-2.5
> 
> it needs to be tested to make sure I captured everything.

I've updated the tarfiles.  For some reason my --exclude directive
didn't stick the first time.  <sigh>

> Justin, this would be why patches are a lot easier to handle:  we have 
> automated scripts to import them rather than having to do error prone
> manual  steps.  All I need to know for a patch is where it was based, and
> I can get  bitkeeper and the tools to do the rest.

Unfortunately, even though I've setup a BK repository in an attempt
to make this task easier, BK doesn't do what I want.  It seems that
only if I can push to a public repository or can export my repository
for others to pull from, will BK auto-matically figure out which change
sets don't exist where and generate the correct stuff.  Unfortunately
my IT department will not allow me to export a BK server, so that is
out of the question.  Anyone care to tell me the magic incantation to
get BK to generate a cumulative patch set against the parent repository?
Or must I do a second clone and manually create patches?

--
Justin
