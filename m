From: thomas schorpp <t.schorpp@gmx.de>
Subject: Re: [usb-storage] [Merging ATA passthru] on integrating	SMART/ATA-Security
 in usb-storage driver
Date: Wed, 09 Nov 2005 11:05:09 +0100
Message-ID: <4371C9D5.1010202@gmx.de>
References: <CA45571DE57E1C45BF3552118BA92C9D69BF4A@WDSCEXBECL03.sc.wdc.com>	<4371BB82.3090208@gmx.de> <4371C557.80807@gmx.de>
Reply-To: t.schorpp@gmx.de
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4371C557.80807@gmx.de>
Sender: linux-ide-owner@vger.kernel.org
To: USB Storage list <usb-storage@lists.one-eyed-alien.net>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-ide@vger.kernel.org, Timothy Thelin <Timothy.Thelin@wdc.com>, Linux SCSI list <linux-scsi@vger.kernel.org>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Patrick Mansfield <patmans@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org

thomas schorpp wrote:
> thomas schorpp wrote:
> 
>>Timothy Thelin wrote:
>>
>>
>>>>On Mon, 7 Nov 2005, James Bottomley wrote:
>>>>
>>>
>>>It was generated against Linus' git repo after
>>>applying Alan's patch.
>>>
>>>With both patches applied I can now do passthru cdbs on the
>>>cypress part without issue, and I still don't see any IO issues.
>>>
>>>Anyone out there have a better selection of hardware to test with?
>>>
>>
>>
>>first i need better software, the 2.6.14-git-11 snapshot wont boot, cause
>>it tries to mount root without detecting partitions before :/
>>
>>did i miss some patch since this snapshot?
>>
> 
> 
> ok, applies against 2.6.14.0. device: cypress -A- bridge.
> 
> no change with smartctl:
> 

err, ok, surely not with missing ata-passthru code ;)

