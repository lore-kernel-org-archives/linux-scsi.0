From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC] relaxed barrier semantics
Date: Fri, 30 Jul 2010 14:56:44 +0200
Message-ID: <20100730125644.GA26118@lst.de>
References: <20100728092859.GA11096@lst.de> <20100729014431.GD4506@thunk.org> <4C51DA1F.2040701@redhat.com> <20100729194904.GA17098@lst.de> <4C51DCF1.3010507@redhat.com> <1280433591.4441.393.camel@mulgrave.site> <20100729200327.GA17767@lst.de> <1280434037.4441.414.camel@mulgrave.site> <20100729201124.GD17767@lst.de> <4C52C94C.2040901@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4C52C94C.2040901@vlnb.net>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@suse.de>, Ric Wheeler <rwheeler@redhat.com>, Ted Ts'o <tytso@mit.edu>, Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>, Jan Kara <jack@suse.cz>, jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp
List-Id: linux-scsi@vger.kernel.org

On Fri, Jul 30, 2010 at 04:45:00PM +0400, Vladislav Bolkhovitin wrote:
> There are also SCSI devices which keep changed settings only until the 
> next reset/restart. (The devices might be shared, so other initiators 
> can at any time reset them.)

I haven't seen a scsi device without support for the saved values
mode pages for years.  But yes, in a shared environment every initator
could change the settings.

