From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Xen-devel] [PATCH V2 2/4] Introduce xen-scsifront module
Date: Fri, 1 Aug 2014 06:41:29 -0700
Message-ID: <20140801134129.GA14525@infradead.org>
References: <1406288253-13293-1-git-send-email-jgross@suse.com>
 <1406288253-13293-3-git-send-email-jgross@suse.com>
 <20140729135300.GA20415@infradead.org>
 <53D7B65C.8030701@suse.com>
 <53D87A67.8050005@suse.com>
 <20140801120847.GB17864@infradead.org>
 <53DB90BC.8000302@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <53DB90BC.8000302@suse.com>
Sender: target-devel-owner@vger.kernel.org
To: Juergen Gross <jgross@suse.com>
Cc: Christoph Hellwig <hch@infradead.org>, target-devel@vger.kernel.org, JBottomley@parallels.com, linux-scsi@vger.kernel.org, xen-devel@lists.xen.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Aug 01, 2014 at 03:06:04PM +0200, Juergen Gross wrote:
> >That's right.  If you need that I still think it's better to add a
> >variant of scsi_add_device helping you with that.
> 
> I'm open to that solution.
> 
> Do you have preferences how to do it (IOW: can you give me a hint)?

I thought about it a bit more and came to the conclusion that we
shouldn't bother.  Why do you care if the scsi_add_device actually
added the device?  Any per-device setup should be done in
->slave_configure anyway.
