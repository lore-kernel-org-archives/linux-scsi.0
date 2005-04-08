From: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: [PATCH] Use proper seq_file api for /proc/scsi/scsi
Date: Fri, 8 Apr 2005 01:10:11 -0700
Message-ID: <20050408081011.GB1018765@sgi.com>
References: <42550173.1040503@suse.de> <20050407103123.GB9586@infradead.org> <425517B3.2010702@suse.de> <20050407112412.GA12072@infradead.org> <20050408072345.GA1018765@sgi.com> <20050408075643.GA5514@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S262757AbVDHITN@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20050408075643.GA5514@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Apr 08, 2005 at 08:56:43AM +0100, Christoph Hellwig wrote:
> On Fri, Apr 08, 2005 at 12:23:46AM -0700, Jeremy Higdon wrote:
> > Even if it's deprecated, wouldn't it be good to fix it as long as
> > it's there, unless it hurts something else?  Or at least fix the
> > out of memory error, even if it doesn't display all the luns?
> 
> What other error would you return?  I don't particularly care what exact

Hmm.  Well maybe you're right -- an error is probably better than no
error if not printing all devices.

> error code to return, but putting in Hannes patch would be a bad idea because
> it
> 
>   a) poke deep into driver model internals, and we absolutely want to avoid
>      that
>   b) sets a bad precedence that we'll continue adding features to deprecated
>      interface and thus encurage people to contiue using it.  Note that
>      /proc/scsi/* has been deprecated since mid-2.5.x.

Just as a sanity check, you meant "lsscsi" and not "lssci" in your original
reply, right?

jeremy
