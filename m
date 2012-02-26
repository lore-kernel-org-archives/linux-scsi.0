From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Solved (for me at least!) GRUB doesn't like ServeRAID M1015/LSI 9220-8i
Date: Sun, 26 Feb 2012 12:57:27 +0000
Message-ID: <4F4A2C37.3090500@anonymous.org.uk>
References: <201201131144.58044.thomas@fjellstrom.ca> <CAKaSfQDyU1a641ZMBNNJJABhXBQxhPGH=E6sNoss=2JyYgFusw@mail.gmail.com> <201202010703.09833.thomas@fjellstrom.ca> <4F294E64.10204@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F294E64.10204@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: thomas@fjellstrom.ca
Cc: Simon McNair <simonmcnair@gmail.com>, linux-kernel@vger.kernel.org, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, ayan@marvell.com, andy yan <andyysj@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 01/02/2012 14:38, John Robinson wrote:
> On 01/02/2012 14:03, Thomas Fjellstrom wrote:
> [...]
>> I picked up a refurb IBM
>> ServeRaid M1015 (aka: LSI 9220-8i) card. It arrived yesterday. Just
>> have to
>> wait and see why grub doesn't like it.
>
> When you find out, please let me know - I bought one via ebay, its
> firmware was elderly and wouldn't let me put it in JBOD mode, after a
> bit of googling I flashed it with IBM's latest firmware, then GRUB
> thought my machine had no RAM in it. The card has been sitting in a box
> since.

RHEL/CentOS 5's GRUB is buggy, in that it doesn't always read the whole 
of the BIOS's memory map. See 
https://bugzilla.redhat.com/show_bug.cgi?id=445893 and in particular 
comment 7 where there's a link to a replacement GRUB which incorporates 
the patch that was first offered to Red Hat in July 2007. The issue 
likely affects other distros GRUBs too, since GRUB is moribund.

Cheers,

John.

