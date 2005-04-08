From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] Use proper seq_file api for /proc/scsi/scsi
Date: Fri, 08 Apr 2005 09:59:57 +0200
Message-ID: <1112947198.6278.20.camel@laptopd505.fenrus.org>
References: <42550173.1040503@suse.de> <20050407103123.GB9586@infradead.org>
	 <425517B3.2010702@suse.de> <20050407112412.GA12072@infradead.org>
	 <20050408072345.GA1018765@sgi.com>  <20050408075643.GA5514@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S262739AbVDHIFE@vger.kernel.org>
In-Reply-To: <20050408075643.GA5514@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jeremy Higdon <jeremy@sgi.com>, Hannes Reinecke <hare@suse.de>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2005-04-08 at 08:56 +0100, Christoph Hellwig wrote:
> On Fri, Apr 08, 2005 at 12:23:46AM -0700, Jeremy Higdon wrote:
> > > It works for those setups that already worked with 2.4.x, aka only a few
> > > luns.
> > 
> > Even if it's deprecated, wouldn't it be good to fix it as long as
> > it's there, unless it hurts something else?  Or at least fix the
> > out of memory error, even if it doesn't display all the luns?
> 
> What other error would you return?  I don't particularly care what exact
> error code to return, but putting in Hannes patch would be a bad idea because
> it
> 
>   a) poke deep into driver model internals, and we absolutely want to avoid
>      that
>   b) sets a bad precedence that we'll continue adding features to deprecated
>      interface and thus encurage people to contiue using it.  Note that
>      /proc/scsi/* has been deprecated since mid-2.5.x.


so how about starting to remove it?
eg give it its final resting date, start defaulting the config option to
"n" and such...
