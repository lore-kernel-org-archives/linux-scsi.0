From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: System hangs when using USB 3.0 HD with on Ubuntu
Date: Wed, 21 Apr 2010 07:58:16 -0700 (PDT)
Message-ID: <25045.92964.qm@web31810.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-hotplug-owner@vger.kernel.org>
Sender: linux-hotplug-owner@vger.kernel.org
To: Mark Lord <mlord@pobox.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Sarah Sharp <sarah.a.sharp@linux.intel.com>, USB Storage List <usb-storage@lists.one-eyed-alien.net>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Lennart Poettering <lennart@poettering.net>, Douglas Gilbert <dgilbert@interlog.com>, Jonas Schwertfeger <jschwertfeger@gmail.com>, "Dinh.Nguyen@freescale.com" <Dinh.Nguyen@freescale.com>, Sergei Shtylyov <sshtylyov@mvista.com>, James Bottomley <James.Bottomley@suse.de>, Kay Sievers <kay.sievers@vrfy.org>, David Zeuthen <david@fubar.dk>, "linux-hotplug@vger.kernel.org" <linux-hotplug@vger.kernel.org>, "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Apr 21, 2010, at 6:52, Mark Lord <mlord@pobox.com> wrote:

On 21/04/10 08:47 AM, Luben Tuikov wrote:
  starts at line 8816.  (It says the
command
is a BLANK command, but it's incorrectly
identified that command.)

Application clients should send ATA PASS-THROUGH (16) and never the 12 byte version to ATAPI devices behind a SAT bridge, whose opcode is interpreted as BLANK (as pointed out by Doug), and BLANK executed.
..

That's a nice self-proclamation.
Got a pointer to a SAT or ATA/SATA standard that says it for real?

If you think this is a "self-proclamation" and want a spec to spell it out, then go ahead and send ATA PT 12 to ATAPI devices behind a SAT bridge. Just make sure there is no RW media in the device. :-) 

The problem with that statement (above), becomes.. what to use
for the initial IDENTIFY request, before the type of device is known?

The statement above tells you: use ATA PT 16.

     Luben



