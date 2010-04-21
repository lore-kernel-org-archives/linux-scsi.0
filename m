From: Mark Lord <mlord@pobox.com>
Subject: Re: System hangs when using USB 3.0 HD with on Ubuntu
Date: Wed, 21 Apr 2010 10:08:37 -0400
Message-ID: <4BCF06E5.1080302@pobox.com>
References: <593030.61801.qm@web31804.mail.mud.yahoo.com>
 <4BCF0310.4000906@pobox.com> <1271858694.2893.47.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-hotplug-owner@vger.kernel.org>
In-Reply-To: <1271858694.2893.47.camel@mulgrave.site>
Sender: linux-hotplug-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: ltuikov@yahoo.com, Alan Stern <stern@rowland.harvard.edu>, Sarah Sharp <sarah.a.sharp@linux.intel.com>, Jonas Schwertfeger <jschwertfeger@gmail.com>, Dinh.Nguyen@freescale.com, Sergei Shtylyov <sshtylyov@mvista.com>, Kay Sievers <kay.sievers@vrfy.org>, David Zeuthen <david@fubar.dk>, linux-hotplug@vger.kernel.org, linux-usb@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, linux-scsi@vger.kernel.org, Lennart Poettering <lennart@poettering.net>, Douglas Gilbert <dgilbert@interlog.com>
List-Id: linux-scsi@vger.kernel.org

On 21/04/10 10:04 AM, James Bottomley wrote:
>
> But this isn't a userspace problem.  By the time we present the device
> to userspace, we already know what it is ... so you can go by device
> type and only use ATA_12 for disk devices.
..

Did you instead mean to say "use ATA_12 for non-disk devices" ?

-- 
Mark Lord
Real-Time Remedies Inc.
mlord@pobox.com
