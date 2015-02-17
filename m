From: Jiri Kosina <jkosina@suse.cz>
Subject: Re: scsi: Implement per-cpu logging buffer
Date: Tue, 17 Feb 2015 14:01:18 +0100 (CET)
Message-ID: <alpine.LRH.2.00.1502171359340.2547@twin.jikos.cz>
References: <20150211191614.349AF660DDA@gitolite.kernel.org> <CAMuHMdUKH1yuLZ9zLAK2STekLFXBufR9PM2_S11xExCtEc9dWg@mail.gmail.com> <54DCAABF.20606@suse.de> <20150212171826.GA31750@thin> <54DDBA64.4060600@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <54DDBA64.4060600@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Josh Triplett <josh@joshtriplett.org>, Geert Uytterhoeven <geert@linux-m68k.org>, Christoph Hellwig <hch@lst.de>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 13 Feb 2015, Hannes Reinecke wrote:

> Thing is, if we were to use per-CPU buffers for printk() out of 
> necessity we have to queue these buffers for writing out. So there is a 
> time window during which the message already is in the per-CPU buffer 
> but still not printed out as printk() is currently writing out one of 
> the other per-CPU buffers.

Please also take a look at per-CPU printk() function redirection mechanism 
that got added because of printk()-from-NMI madness ('printk_func' 
pointer). It might be useful for your purposes as well.

-- 
Jiri Kosina
SUSE Labs
