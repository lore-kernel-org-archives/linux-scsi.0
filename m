From: Christoph Hellwig <hch@infradead.org>
Subject: Re: One more change pushed to bk tree
Date: Fri, 22 Nov 2002 22:56:04 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021122225604.A13466@infradead.org>
References: <20021122183603.GC16865@redhat.com> <20021122204538.A10657@infradead.org> <20021122222247.GB18664@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hch by phoenix.infradead.org with local (Exim 4.10)
	id 18FMiT-0003Vj-00
	for linux-scsi@vger.kernel.org; Fri, 22 Nov 2002 22:56:05 +0000
Content-Disposition: inline
In-Reply-To: <20021122222247.GB18664@redhat.com>; from dledford@redhat.com on Fri, Nov 22, 2002 at 05:22:47PM -0500
List-Id: linux-scsi@vger.kernel.org
To: Linux Scsi Mailing List <linux-scsi@vger.kernel.org>

On Fri, Nov 22, 2002 at 05:22:47PM -0500, Doug Ledford wrote:
> > Two comments: 
> > 
> >  o as you already had to change all callers of host->host_queue/
> >    host->my_devices could you add a lock to properly protect it?  That's
> >    pretty important for hotplugging/etc.. (like the fc hotplug patch
> >    from montavista)
> 
> I'm actually thinking that the locking of the devices is not needed as 
> long as the next step is to A) make sure that all people walking the 
> my_devices list already are holding a reference to the parent host vi 
> host_get_*() and B) that proper locking for hosts is actually implemented 
> in the host_get*() routines instead of the stub comments that are there 
> now.

Yupp.

