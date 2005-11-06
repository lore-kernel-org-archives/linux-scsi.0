From: thomas schorpp <t.schorpp@gmx.de>
Subject: Re: [usb-storage] [Merging ATA passthru] on integrating	SMART/ATA-Security
 in usb-storage driver
Date: Sun, 06 Nov 2005 04:38:35 +0100
Message-ID: <436D7ABB.6070706@gmx.de>
References: <CA45571DE57E1C45BF3552118BA92C9D69BF3F@WDSCEXBECL03.sc.wdc.com>	 <1131130707.3532.45.camel@mulgrave>	 <20051104203004.GF12384@one-eyed-alien.net>	 <1131137395.3532.57.camel@mulgrave>	 <20051105235522.GA21733@one-eyed-alien.net> <1131238146.9430.7.camel@mulgrave>
Reply-To: t.schorpp@gmx.de
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1131238146.9430.7.camel@mulgrave>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Timothy Thelin <Timothy.Thelin@wdc.com>, usb-storage@lists.one-eyed-alien.net, linux-ide@vger.kernel.org, Linux SCSI list <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Sat, 2005-11-05 at 15:55 -0800, Matthew Dharm wrote:
> 
>>On Fri, Nov 04, 2005 at 02:49:55PM -0600, James Bottomley wrote: 
>>
>>>Can you just try it with a modern kernel and see if anything still
>>>breaks?
>>
>>I just realized this plan has a problem...
>>
>>The reported SCSI level of a device is mostly garbage, but not always.
>>I've seen 0, 1, 2, 3, and 0xff all reported.  HOWEVER, the reported value
>>seems independent of what devices have vendor-specific commands (and thus
>>need the CDB[1] not messed with).
>>
>>It is an interesting experiment to remove the force-to-SCSI_2 part of the
>>usb-storage code (on the general principal of "we shouldn't be messing with
>>the data passed through the driver), but it doesn't solve the original
>>question of needing a way to pass commands without CDB[1] getting altered.
> 
> 
> Well, that might be a problem if it weren't for the fact that this
> LUN_INHIBIT flag was removed in 2002.  If it's taken three years to find
> a device that has a problem with it, I don't really think it's a
> particularly widespread problem.  And since the device that now shows
> the problem is setting the level to 0, it looks like we have a potential
> solution that fits all known cases.
> 
> Anyway, the goal should be to handle devices in a standards compliant
> manner first and then worry about quirk tables when that doesn't
> work ... we have an incredibly broad quirk infrastructure in SCSI for
> this.
> 
> James
> 

ok, ive just ordered 2 cypress CY7C68300B samples and will replace the discont'd A type in my device.
datasheet for A says nothing about ATACB and security. sheet for B does guarantee.

cypress windows driver reports no security, too.

so i will replace the chip to have a testing base.

tom





