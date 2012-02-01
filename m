From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: GRUB doesn't like ServeRAID M1015/LSI 9220-8i (was Re: mvsas
 with 3.1)
Date: Wed, 01 Feb 2012 15:27:54 +0000
Message-ID: <4F2959FA.70101@anonymous.org.uk>
References: <201201131144.58044.thomas@fjellstrom.ca> <201202010703.09833.thomas@fjellstrom.ca> <4F294E64.10204@anonymous.org.uk> <201202010742.07818.thomas@fjellstrom.ca> <4F295769.6070003@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4F295769.6070003@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: thomas@fjellstrom.ca, linux-raid <linux-raid@vger.kernel.org>, linux-kernel@vger.kernel.org, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 01/02/2012 15:16, Hannes Reinecke wrote:
> On 02/01/2012 03:42 PM, Thomas Fjellstrom wrote:
>> On Wed Feb 1, 2012, John Robinson wrote:
>>> On 01/02/2012 14:03, Thomas Fjellstrom wrote:
>>> [...]
>>>>  I picked up a refurb IBM
>>>> ServeRaid M1015 (aka: LSI 9220-8i) card. It arrived yesterday. Just have
>>>> to wait and see why grub doesn't like it.
>>>
>>> When you find out, please let me know - I bought one via ebay, its
>>> firmware was elderly and wouldn't let me put it in JBOD mode, after a
>>> bit of googling I flashed it with IBM's latest firmware, then GRUB
>>> thought my machine had no RAM in it.
[...]
>
> From my experience the BIOS wouldn't present any disks in JBOD mode.
> So you'd be needing to switch to RAID mode first.

The firmware my card came with didn't have a JBOD mode, which is why I 
flashed the newer firmware. Then I could boot in JBOD mode from a rescue 
CD and see some drives, though not those that had had RAID-mode metadata 
written to them, but I couldn't boot the system with GRUB (from drives 
on another controller).

Cheers,

John.
