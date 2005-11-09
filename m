From: thomas schorpp <t.schorpp@gmx.de>
Subject: Re: [usb-storage] [Merging ATA passthru] on integrating SMART/ATA-Security
 in usb-storage driver
Date: Wed, 09 Nov 2005 10:04:02 +0100
Message-ID: <4371BB82.3090208@gmx.de>
References: <CA45571DE57E1C45BF3552118BA92C9D69BF4A@WDSCEXBECL03.sc.wdc.com>
Reply-To: t.schorpp@gmx.de
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <CA45571DE57E1C45BF3552118BA92C9D69BF4A@WDSCEXBECL03.sc.wdc.com>
Sender: linux-ide-owner@vger.kernel.org
To: Timothy Thelin <Timothy.Thelin@wdc.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@SteelEye.com>, Patrick Mansfield <patmans@us.ibm.com>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, Linux SCSI list <linux-scsi@vger.kernel.org>, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Timothy Thelin wrote:
>>On Mon, 7 Nov 2005, James Bottomley wrote:
>>
> It was generated against Linus' git repo after
> applying Alan's patch.
> 
> With both patches applied I can now do passthru cdbs on the
> cypress part without issue, and I still don't see any IO issues.
> 
> Anyone out there have a better selection of hardware to test with?
> 

first i need better software, the 2.6.14-git-11 snapshot wont boot, cause
it tries to mount root without detecting partitions before :/

did i miss some patch since this snapshot?

