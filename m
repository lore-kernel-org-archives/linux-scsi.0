From: William Lee Irwin III <wli@holomorphy.com>
Subject: Re: Adaptec 39160 / Yamaha CRW8424S CD burning
Date: Mon, 13 Jan 2003 00:11:44 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030113081144.GB9558@holomorphy.com>
References: <20030113071543.GA9558@holomorphy.com> <3E22738D.3020000@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3E22738D.3020000@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi@vger.kernel.org, gibbs@scsiguy.com

On Mon, Jan 13, 2003 at 07:06:37PM +1100, Douglas Gilbert wrote:
> Depending on which version of cdrecord you are using,
> cdrecord will get to the SCSI Yamaha burner via:
>   - scsi generic (sg) device (probably /dev/sg1)
>   - or directly to /dev/scd0 (via the SG_IO ioctl in
>     the block layer)
>   - or via /dev/scd0 using the CDROM_PACKET_COMMAND
>     ioctl
> Could you determine which one is happening? If the
> sg route is being used then the individual SCSI
> commands can be seen by observing 'cat /proc/scsi/sg/debug'
> while the burn is in progress. What version of cdrecord
> are you using and what does its output look like?

It's sg (SG_IO ioctl's), the version of cdrecord I use always uses it.
I'm also running without your fixes. I've got enough blanks, I'll do
a test run anyway if you still need me to run it.


Thanks,
Bill
