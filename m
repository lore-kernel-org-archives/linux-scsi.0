From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] SCSI Core patches
Date: Sat, 11 Jan 2003 18:12:24 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030111181224.B3178@infradead.org>
References: <3E1ADC9A.6090800@splentec.com> <20030107102127.B15528@beaverton.ibm.com> <3E1B2934.8060805@splentec.com> <20030107123301.A16378@beaverton.ibm.com> <3E1B513B.2090409@splentec.com> <20030107173633.A17825@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030107173633.A17825@beaverton.ibm.com>; from patmans@us.ibm.com on Tue, Jan 07, 2003 at 05:36:33PM -0800
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Luben Tuikov <luben@splentec.com>, linux-scsi@vger.kernel.org

On Tue, Jan 07, 2003 at 05:36:33PM -0800, Patrick Mansfield wrote:
> Having the LLDD use more data structures does not imply a better
> abstraction.  Again, a better abstraction would be to use interfaces to
> get the host/channel/target/lun. This could add overhead depending on the
> implementation.

Not having the cmnd replicate information in the device implies a better
abstraction :)  The LLDD knows about struct scsi_device anyway.

> > For this reason you might consider the suggestions by Doug, or research moving
> > multipathing higher up into the char/block layer, or thereabouts.
> 
> I have looked into putting multipath in the block layer, I've looked at
> md, at the T3 code, and at the qlogic multi-path code. Code in the block
> layer would be interesting, but might not solve problems with char
> devices,

Scsi character drivers _do_ go through the block layer.  (through
scsi_do_req).

