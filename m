From: Mark Lord <mlord@pobox.com>
Subject: Re: System hangs when using USB 3.0 HD with on Ubuntu
Date: Wed, 12 May 2010 10:45:51 -0400
Message-ID: <4BEABF1F.6080800@pobox.com>
References: <Pine.LNX.4.44L0.1005111022130.1834-100000@iolanthe.rowland.org>
 <4BEAA583.1090805@pobox.com> <4BEAB9F6.60601@interlog.com>
 <4BEABD19.6020005@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-hotplug-owner@vger.kernel.org>
In-Reply-To: <4BEABD19.6020005@pobox.com>
Sender: linux-hotplug-owner@vger.kernel.org
To: dgilbert@interlog.com
Cc: Alan Stern <stern@rowland.harvard.edu>, Jonas Schwertfeger <jschwertfeger@gmail.com>, Sarah Sharp <sarah.a.sharp@linux.intel.com>, Dinh.Nguyen@freescale.com, Sergei Shtylyov <sshtylyov@mvista.com>, James Bottomley <James.Bottomley@suse.de>, Kay Sievers <kay.sievers@vrfy.org>, David Zeuthen <david@fubar.dk>, linux-hotplug@vger.kernel.org, linux-usb@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, linux-scsi@vger.kernel.org, Lennart Poettering <lennart@poettering.net>
List-Id: linux-scsi@vger.kernel.org

On 12/05/10 10:37 AM, Mark Lord wrote:
> On 12/05/10 10:23 AM, Douglas Gilbert wrote:
>> Mark,
>> Not sure if this bug got out into the wild but it
>> sounds close to what you are describing:
>> https://bugzilla.kernel.org/show_bug.cgi?id=15185
> ..
>
> I don't think that is the exact issue here.
> But can you send me the patch that is referred to in that bugzilla entry?
>
> I've been noticing issues with the DSM TRIM command in newer kernels,
> and I wonder if this might have something to do with that.
..

Okay, I found the patch/commit, and my 2.6.32.5 kernel was missing it.
Pulling down the latest 2.6.32.* tree now to see if it ever made it there.

But that patch is for libata, which is not on the pathway
for this USB3 issue.

Cheers
-- 
Mark Lord
Real-Time Remedies Inc.
mlord@pobox.com
