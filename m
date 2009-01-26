From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: Spamming linux-kernel and linux-scsi by out-of-tree patches
	(LIO)
Date: Mon, 26 Jan 2009 09:15:24 -0800
Message-ID: <1232990124.24642.156.camel@haakon2.linux-iscsi.org>
References: <497DB7D0.8000302@vlnb.net>
	 <1232984234.3248.18.camel@localhost.localdomain>
	 <497DDFF8.8070707@vlnb.net>  <20090126081905.7c112170@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp122.sbc.mail.sp1.yahoo.com ([69.147.64.95]:24365 "HELO
	smtp122.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750775AbZAZRPs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Jan 2009 12:15:48 -0500
In-Reply-To: <20090126081905.7c112170@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, 2009-01-26 at 08:19 -0800, Arjan van de Ven wrote:
> On Mon, 26 Jan 2009 19:08:24 +0300
> Vladislav Bolkhovitin <vst@vlnb.net> wrote:
> 
> > I wouldn't object if Nicholas des the same and send in linux-scsi
> > and linux-kernel a complete patchset, which we will review and
> > discuss. But he sends *intermediate* patches and this looks for me
> > like a violation of fundamental rules/intention of Linux kernel
> > mailing lists, hence I complain.
> > 
> > So, should I understand your words that you agree if I also start 
> > sending intermediate patches for SCST to linux-scsi/linux-kernel?
> > 
> 
> 
> <looking in as an outsider>
> 
> I am thoroughly surprised by this email exchange.
> From where I sit, there is almost no such thing as posting patches too
> early. Really. Transparency and early review/feedaback is by far
> more important than ignoring a few more patches in an area you
> don't careabout.
> 

For those wanting to know more about "Release Early, Release Often":

http://www.catb.org/~esr/writings/cathedral-bazaar/cathedral-bazaar/ar01s04.html

<SNIP>

Linus's open development policy was the very opposite of
cathedral-building. Linux's Internet archives were burgeoning, multiple
distributions were being floated. And all of this was driven by an
unheard-of frequency of core system releases.

Linus was treating his users as co-developers in the most effective
possible way:

        7. Release early. Release often. And listen to your customers.
        

Linus's innovation wasn't so much in doing quick-turnaround releases
incorporating lots of user feedback (something like this had been
Unix-world tradition for a long time), but in scaling it up to a level
of intensity that matched the complexity of what he was developing. In
those early times (around 1991) it wasn't unknown for him to release a
new kernel more than once a day! Because he cultivated his base of
co-developers and leveraged the Internet for collaboration harder than
anyone else, this worked.

<SNIP>

--nab

