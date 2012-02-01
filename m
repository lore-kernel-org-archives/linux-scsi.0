From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Subject: Re: GRUB doesn't like ServeRAID M1015/LSI 9220-8i (was Re: mvsas with 3.1)
Date: Wed, 1 Feb 2012 08:22:07 -0700
Message-ID: <201202010822.07647.thomas@fjellstrom.ca>
References: <201201131144.58044.thomas@fjellstrom.ca> <201202010742.07818.thomas@fjellstrom.ca> <4F295769.6070003@suse.de>
Reply-To: thomas@fjellstrom.ca
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4F295769.6070003@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: John Robinson <john.robinson@anonymous.org.uk>, linux-raid <linux-raid@vger.kernel.org>, linux-kernel@vger.kernel.org, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed Feb 1, 2012, Hannes Reinecke wrote:
> On 02/01/2012 03:42 PM, Thomas Fjellstrom wrote:
> > On Wed Feb 1, 2012, John Robinson wrote:
> >> On 01/02/2012 14:03, Thomas Fjellstrom wrote:
> >> [...]
> >> 
> >>>  I picked up a refurb IBM
> >>> 
> >>> ServeRaid M1015 (aka: LSI 9220-8i) card. It arrived yesterday. Just
> >>> have to wait and see why grub doesn't like it.
> >> 
> >> When you find out, please let me know - I bought one via ebay, its
> >> firmware was elderly and wouldn't let me put it in JBOD mode, after a
> >> bit of googling I flashed it with IBM's latest firmware, then GRUB
> >> thought my machine had no RAM in it. The card has been sitting in a box
> >> since.
> > 
> > Yeah, GRUB immediately throws an "out of memory. Aborted" error, its
> > annoying, but I reported the issue on GRUB's bug tracker after talking
> > to a guy in #grub on freenode. Hopefully someone looks at it soon. It
> > appears it happens so early in grub's startup that it can't even output
> > any debug info (I was asked to run: `grub-install --debug-image=all
> > /dev/sdX`, and did so, I get debug output when the card is not
> > installed, but absolutely nothing when it is installed.
> 
> From my experience the BIOS wouldn't present any disks in JBOD mode.
> So you'd be needing to switch to RAID mode first.

It does seem to notice them all in its own bios, and list them in JBOD mode. 
But the disks aren't used for booting, so at the very least it shouldn't affect 
booting at all. But I'll try that out anyhow to see if it "fixes" GRUB.

> Cheers,
> 
> Hannes


-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
