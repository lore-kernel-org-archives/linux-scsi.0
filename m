From: Orion Poplawski <orion@colorado-research.com>
Subject: Re: Exabyte tape device hangs writing large file - sym53c8xxx driver
Date: Thu, 17 Oct 2002 09:20:33 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200210171520.g9HFKYf13186@earth.colorado-research.com>
References: <200210162019.g9GKJBTh000816@darkstar.example.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <200210162019.g9GKJBTh000816@darkstar.example.net>
List-Id: linux-scsi@vger.kernel.org
To: jbradford@dial.pipex.com
Cc: linux-scsi@vger.kernel.org

On Wednesday 16 October 2002 02:19 pm, jbradford@dial.pipex.com wrote:
> > I have a working Exabyte 8505 8mm tape drive that was put in a new Linux
> > box with a Symbios dual channel 53c1010-33 SCSI adapter.  Three external
> > disk drives sit on the first bus, and the tape drive is by itself on the
> > internal (second) bus.  Each bus is properly terminated, the internal
> > tape drive is connected via a 50-pin ribbon cable.
> >
> > I'm using a custom SMP kernel, version 2.4.19, under redhat 7.2.
> >
> > When writing to the device with tar, it hangs when it reaches a
> > large file
>
> Try disabling disconnection in the SCSI bios, just for that device.
>
> John.

Did not appear to have any effect.

I'm seeing the same problem reading large files from a tape:

$ tar xvf /dev/st0
990723/
990723/IMGR990723.2157

-rw-r--r--    1 orion    cora     47420416 Oct 17 09:07 IMGR990723.2157

This is as far as the read got, then it hung.

