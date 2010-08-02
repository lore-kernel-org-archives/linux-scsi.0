From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC] relaxed barrier semantics
Date: Mon, 2 Aug 2010 14:48:30 +0200
Message-ID: <20100802124830.GB22345@lst.de>
References: <25F5E16E-968D-4FEF-8187-70453985B19B@dilger.ca> <20100729230406.GI4506@thunk.org> <4C52CBFF.6090406@vlnb.net> <20100730130957.GA26894@lst.de> <4C52D2E0.5000609@vlnb.net> <20100730133410.GA27996@lst.de> <4C52D728.6070008@vlnb.net> <20100730142025.GA29341@lst.de> <20100731004756.GC3273@quack.suse.cz> <4C56A01A.1050107@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:45085 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753275Ab0HBMtE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Aug 2010 08:49:04 -0400
Content-Disposition: inline
In-Reply-To: <4C56A01A.1050107@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>, Ted Ts'o <tytso@mit.edu>, Andreas Dilger <adilger@dilger.ca>, Ric Wheeler <rwheeler@redhat.com>, Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>, jaxboe@fusionio.com, James.Bottomley@suse.de, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp

On Mon, Aug 02, 2010 at 02:38:18PM +0400, Vladislav Bolkhovitin wrote:
> >   Umm, I don't understand you. I think that fsync in particular is an
> >example where you have to wait and issue cache flush if the drive has
> >volatile write cache. Otherwise you cannot promise to the user data will be
> >really on disk in case of crash. So no ordering helps you.
> 
> Isn't there the second wait for journal update?

Yes.

> A drive can reorder queued SIMPLE requests at any time doesn't matter if 
> it has volatile write caches or not.

I know.

> So, if you expect in-order requests 
> execution (with journal updates you do?), you need to enforce that order 
> either by ORDERED requests or (local) queue draining.

Yes, exactly what I say.

