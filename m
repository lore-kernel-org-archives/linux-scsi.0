From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: SCSI TMF processing; tag allocation
Date: Mon, 15 Nov 2010 12:09:02 -0700
Message-ID: <20101115190901.GB6178@parisc-linux.org>
References: <380694.87733.qm@web31812.mail.mud.yahoo.com> <4CE181A8.8050102@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4CE181A8.8050102@interlog.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: ltuikov@yahoo.com, Greg KH <greg@kroah.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, tj@kernel.org, jens.axboe@oracle.com, James.Bottomley@suse.de
List-Id: linux-scsi@vger.kernel.org

On Mon, Nov 15, 2010 at 01:53:28PM -0500, Douglas Gilbert wrote:
> On the subject of UAS, due to some USB-3 streaming protocol
> requirements, three tag values cannot be used by SCSI. They
> are 0h, FFFEh and FFFFh. So those available for SCSI tag
> use are 1h to FFFDh inclusive.

I add 1 to the tag value handed to me by the block layer, and use that
as the tag value that I tell the UAS device this command has.  So if I
ask for 256 tags, I'll hand values 1-257 to the device.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
