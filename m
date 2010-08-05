From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC] relaxed barrier semantics
Date: Thu, 5 Aug 2010 21:40:46 +0200
Message-ID: <20100805194046.GA18518@lst.de>
References: <4C4FECFE.9040509@kernel.org> <20100728085048.GA8884@lst.de> <4C4FF136.5000205@kernel.org> <20100728090025.GA9252@lst.de> <4C4FF592.9090800@kernel.org> <20100728092859.GA11096@lst.de> <20100802173930.GP16630@think> <4C5AB89C.5080700@vlnb.net> <20100805170933.GB10728@lst.de> <4C5B11B4.9020807@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4C5B11B4.9020807@vlnb.net>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Christoph Hellwig <hch@lst.de>, Chris Mason <chris.mason@oracle.com>, Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>, Jan Kara <jack@suse.cz>, jaxboe@fusionio.com, James.Bottomley@suse.de, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, tytso@mit.edu, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp
List-Id: linux-scsi@vger.kernel.org

On Thu, Aug 05, 2010 at 11:32:04PM +0400, Vladislav Bolkhovitin wrote:
> New flag.. Easy to add, hard to live with. Aren't you already tied of 
> the existing flags hell?

I'm tired of flags without a very well defined meaning.  For example
I'm really tired of the current REQ_HARDBARRIER because it means so
amy different things.

A must do pre-flush or must do FUA flag is very different from a must
not reorder flag.  Overloading the meaning is what got us into this
mess.
