From: Christoph Hellwig <hch@infradead.org>
Subject: Re: One more change pushed to bk tree
Date: Fri, 22 Nov 2002 20:45:38 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021122204538.A10657@infradead.org>
References: <20021122183603.GC16865@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hch by phoenix.infradead.org with local (Exim 4.10)
	id 18FKgE-0002p8-00
	for linux-scsi@vger.kernel.org; Fri, 22 Nov 2002 20:45:38 +0000
Content-Disposition: inline
In-Reply-To: <20021122183603.GC16865@redhat.com>; from dledford@redhat.com on Fri, Nov 22, 2002 at 01:36:03PM -0500
List-Id: linux-scsi@vger.kernel.org
To: Linux Scsi Mailing List <linux-scsi@vger.kernel.org>

On Fri, Nov 22, 2002 at 01:36:03PM -0500, Doug Ledford wrote:
> Like last time, this has been through a full compile test, but not a boot 
> test.  I'm heading up to the office next so the boot test will come 
> shortly.  But, because it touches lots of files, again, I thought I would 
> go ahead and push it up for people to see.  If there are no objections to 
> this or my previous patches, then once the boot test is complete and I'm 
> satisfied things are working properly, I'll push the whole lot to Linus 
> (which will necessarily include the scsi-misc-2.5 changes because they are 
> in my tree as well).

Heh, now you managed to get stuff commited before me and I need to merge
up :)  But your changes help me a lot in fact so I surely won't complain.

Two comments: 

 o as you already had to change all callers of host->host_queue/
   host->my_devices could you add a lock to properly protect it?  That's
   pretty important for hotplugging/etc.. (like the fc hotplug patch
   from montavista)
 o what's the reason in continuing after an error from scsi_add_host
   in scsi_add_host?  IMHO it doesn't make much sense to continue the
   bus scan in that case.

