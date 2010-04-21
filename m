From: Mark Lord <mlord@pobox.com>
Subject: Re: System hangs when using USB 3.0 HD with on Ubuntu
Date: Wed, 21 Apr 2010 09:52:16 -0400
Message-ID: <4BCF0310.4000906@pobox.com>
References: <593030.61801.qm@web31804.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-hotplug-owner@vger.kernel.org>
In-Reply-To: <593030.61801.qm@web31804.mail.mud.yahoo.com>
Sender: linux-hotplug-owner@vger.kernel.org
To: ltuikov@yahoo.com
Cc: Alan Stern <stern@rowland.harvard.edu>, Sarah Sharp <sarah.a.sharp@linux.intel.com>, Jonas Schwertfeger <jschwertfeger@gmail.com>, Dinh.Nguyen@freescale.com, Sergei Shtylyov <sshtylyov@mvista.com>, James Bottomley <James.Bottomley@suse.de>, Kay Sievers <kay.sievers@vrfy.org>, David Zeuthen <david@fubar.dk>, linux-hotplug@vger.kernel.org, linux-usb@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, linux-scsi@vger.kernel.org, Lennart Poettering <lennart@poettering.net>, Douglas Gilbert <dgilbert@interlog.com>
List-Id: linux-scsi@vger.kernel.org

On 21/04/10 08:47 AM, Luben Tuikov wrote:
>>>>    starts at line 8816.  (It says the
>> command
>>>> is a BLANK command, but it's incorrectly
>> identified that command.)
>
> Application clients should send ATA PASS-THROUGH (16) and never the 12 byte version to ATAPI devices behind a SAT bridge, whose opcode is interpreted as BLANK (as pointed out by Doug), and BLANK executed.
..

That's a nice self-proclamation.
Got a pointer to a SAT or ATA/SATA standard that says it for real?

The problem with that statement (above), becomes.. what to use
for the initial IDENTIFY request, before the type of device is known?

Cheers
-- 
Mark Lord
Real-Time Remedies Inc.
mlord@pobox.com
