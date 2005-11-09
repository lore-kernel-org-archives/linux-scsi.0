From: Mark Lord <liml@rtr.ca>
Subject: Re: [usb-storage] [Merging ATA passthru] on integrating	SMART/ATA-Security
 in usb-storage driver
Date: Wed, 09 Nov 2005 08:21:07 -0500
Message-ID: <4371F7C3.5080702@rtr.ca>
References: <CA45571DE57E1C45BF3552118BA92C9D69BF4A@WDSCEXBECL03.sc.wdc.com> <4371BB82.3090208@gmx.de> <4371C557.80807@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rtr.ca ([64.26.128.89]:53967 "EHLO mail.rtr.ca")
	by vger.kernel.org with ESMTP id S1750721AbVKINVE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Nov 2005 08:21:04 -0500
In-Reply-To: <4371C557.80807@gmx.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: t.schorpp@gmx.de
Cc: USB Storage list <usb-storage@lists.one-eyed-alien.net>, Timothy Thelin <Timothy.Thelin@wdc.com>, James Bottomley <James.Bottomley@SteelEye.com>, linux-ide@vger.kernel.org, Linux SCSI list <linux-scsi@vger.kernel.org>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Patrick Mansfield <patmans@us.ibm.com>

 >no change with smartctl:
 >tom1:/usr/src/sm5/debug# ./smartctl -a -r ioctl,2 -T verypermissive /dev/sda

Shouldn't there be a "-d ata" flag on those smartctl commands?
