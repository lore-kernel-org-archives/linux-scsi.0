From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [ANNOUNCE]: version 2.00.3 megaraid driver for 2.4.x and 2.5.67 kernels
Date: Thu, 17 Apr 2003 14:56:20 +0100
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20030417145620.A14452@infradead.org>
References: <20030417135719.A13189@infradead.org> <200304171323.h3HDNYm17322@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200304171323.h3HDNYm17322@devserv.devel.redhat.com>; from alan@redhat.com on Thu, Apr 17, 2003 at 09:23:34AM -0400
To: Alan Cox <alan@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Mukker Atul <atulm@lsil.com>, "'James.Bottomley@steeleye.com'" <James.Bottomley@steeleye.com>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "'linux-megaraid-devel@dell.com'" <linux-megaraid-devel@dell.com>, "'linux-megaraid-announce@dell.com'" <linux-megaraid-announce@dell.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Apr 17, 2003 at 09:23:34AM -0400, Alan Cox wrote:
> > This is a 2.5-only driver (in fact a 2.5 only patch against a 2.4 driver)
> 
> 2.0 exists for 2.4 as well. I dont know about for 2.2

Is my English that bad? :)

Currently the megaraid2 driver is distributed as a tarball that works _only_
with Linux 2.4 (and it looks like only with rather recent 2.4 versions), and
there is a patch against it to make it work with 2.5 and only 2.5.
