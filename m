From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Aic7xxx v6.2.22 and Aic79xx v1.3.0Alpha2 Released
Date: Tue, 10 Dec 2002 14:58:26 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200212102058.gBAKwQm04407@localhost.localdomain>
References: <gibbs@scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id MAA19736
	for <linux-scsi@vger.kernel.org>; Tue, 10 Dec 2002 12:58:34 -0800
In-Reply-To: Message from "Justin T. Gibbs" <gibbs@scsiguy.com>
   of "Tue, 10 Dec 2002 13:03:30 MST." <649720000.1039550610@aslan.btc.adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>, Marcelo Tosatti <marcelo@conectiva.com.br>, Linus Torvalds <torvalds@transmeta.com>

gibbs@scsiguy.com said:
> Unfortunately, even though I've setup a BK repository in an attempt to
> make this task easier, BK doesn't do what I want.  It seems that only
> if I can push to a public repository or can export my repository for
> others to pull from, will BK auto-matically figure out which change
> sets don't exist where and generate the correct stuff.  Unfortunately
> my IT department will not allow me to export a BK server, so that is
> out of the question.  Anyone care to tell me the magic incantation to
> get BK to generate a cumulative patch set against the parent
> repository? Or must I do a second clone and manually create patches? 

You can "borrow" a public repository on bkbits.net.  See 
http://www.bitkeeper.com/Hosted.html

There isn't a way to diff two respositories, but you can see the differences 
with bk changes -{L|R} <other repository> and make diffs for each change set. 
(alternatively, if the child is just the parent with only your patches tacked 
on, you can diff from the common ancestor).

James


