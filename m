From: Andries Brouwer <aebr@win.tue.nl>
Subject: Re: New model for managing dev_t's for partitionable block devices
Date: Wed, 29 Jan 2003 18:38:37 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030129173837.GA3979@win.tue.nl>
References: <OFD9CDB238.908E6C3C-ON87256CBD.00070A30-88256CBD.00095D4B@us.ibm.com> <3E380532.2010900@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3E380532.2010900@mvista.com>
List-Id: linux-scsi@vger.kernel.org
To: Steven Dake <sdake@mvista.com>
Cc: Bryan Henderson <hbryan@us.ibm.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Douglas Gilbert <dougg@torque.net>, Christoph Hellwig <hch@infradead.org>, Joel Becker <Joel.Becker@oracle.com>, Kurt Garloff <kurt@garloff.de>, linux-kernel@kernel.vger.org, Linux SCSI list <linux-scsi@vger.kernel.org>

On Wed, Jan 29, 2003 at 09:45:38AM -0700, Steven Dake wrote:

> What is needed is a compromise, described above, limiting the number of 
> partitions to some sane amount, but allowing significantly more disks 
> for the power user.

Always this discussion, over and over again.
Changing dev_t to be 32-bit is something many people that take part
in this discussion could do in a few hours. The subsequent kernel
audit takes a weekend.
Is there a reason everybody prefers to discuss ugly hacks?

Andries
