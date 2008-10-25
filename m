From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: usb hdd problems with 2.6.27.2
Date: Sat, 25 Oct 2008 21:25:43 +0200
Message-ID: <200810252125.44184.rjw@sisk.pl>
References: <20081022162246.GB5649@bit.office.eurotux.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([217.79.144.158]:51346 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751929AbYJYTVM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 25 Oct 2008 15:21:12 -0400
In-Reply-To: <20081022162246.GB5649@bit.office.eurotux.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luciano Rocha <luciano@eurotux.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>, SCSI development list <linux-scsi@vger.kernel.org>

[Adding CCs]

On Wednesday, 22 of October 2008, Luciano Rocha wrote:
> 
> Hello,
> 
> An external HDD, usb-encased, works fine under 2.6.26.5, but under
> 2.6.27.2 I get hundreds of errors per second, of 'No Sense [current]'.
> 
> On connection, under 2.6.26.5, I get the following:
> 
> [   84.503949] usb 1-2.1.1: new high speed USB device using ehci_hcd and address 8
> [   84.696861] usb 1-2.1.1: configuration #1 chosen from 1 choice
> [   84.740856] usbcore: registered new interface driver libusual
> [   84.817625] Initializing USB Mass Storage driver...
> [   84.817625] scsi2 : SCSI emulation for USB Mass Storage devices
> [   84.818820] usbcore: registered new interface driver usb-storage
> [   84.818823] USB Mass Storage support registered.
> [   89.819567] scsi 2:0:0:0: Direct-Access     SAMSUNG  HD400LD          WQ10 PQ: 0 ANSI: 0
> [   89.857627] Driver 'sd' needs updating - please use bus_type methods
> [   89.857837] sd 2:0:0:0: [sda] 781422769 512-byte hardware sectors (400088 MB)
> [   89.858754] sd 2:0:0:0: [sda] Write Protect is off
> [   89.858754] sd 2:0:0:0: [sda] Assuming drive cache: write through
> [   89.858869] sd 2:0:0:0: [sda] 781422769 512-byte hardware sectors (400088 MB)
> [   89.858869] sd 2:0:0:0: [sda] Write Protect is off
> [   89.858869] sd 2:0:0:0: [sda] Assuming drive cache: write through
> [   89.858869]  sda: sda1
> [   89.879851] sd 2:0:0:0: [sda] Attached SCSI disk
> [   89.901630] sd 2:0:0:0: Attached scsi generic sg0 type 0
> [   89.963632] sd 2:0:0:0: [sda] Sense Key : No Sense [current] 
> [   89.963632] sd 2:0:0:0: [sda] Add. Sense: No additional sense information
> [  106.913629] kjournald starting.  Commit interval 5 seconds
> [  106.913629] EXT3 FS on dm-5, internal journal
> 
> On 2.6.27.2, I get:
> 
> [  551.484341] usb 1-2.1.1: new high speed USB device using ehci_hcd and address 8
> [  551.677467] usb 1-2.1.1: configuration #1 chosen from 1 choice
> [  551.718201] usbcore: registered new interface driver libusual
> [  551.799287] Initializing USB Mass Storage driver...
> [  551.800330] scsi2 : SCSI emulation for USB Mass Storage devices
> [  551.800694] usbcore: registered new interface driver usb-storage
> [  551.800698] USB Mass Storage support registered.
> [  556.800702] scsi 2:0:0:0: Direct-Access     SAMSUNG  HD400LD          WQ10 PQ: 0 ANSI: 0
> [  556.835190] Driver 'sd' needs updating - please use bus_type methods
> [  556.835928] sd 2:0:0:0: [sda] 781422769 512-byte hardware sectors (400088 MB)
> [  556.836809] sd 2:0:0:0: [sda] Write Protect is off
> [  556.836816] sd 2:0:0:0: [sda] Assuming drive cache: write through
> [  556.837548] sd 2:0:0:0: [sda] 781422769 512-byte hardware sectors (400088 MB)
> [  556.838296] sd 2:0:0:0: [sda] Write Protect is off
> [  556.838307] sd 2:0:0:0: [sda] Assuming drive cache: write through
> [  556.838310]  sda: sda1
> [  556.859169] sd 2:0:0:0: [sda] Attached SCSI disk
> [  556.878553] sd 2:0:0:0: Attached scsi generic sg0 type 0
> [  556.946044] sd 2:0:0:0: [sda] Sense Key : No Sense [current] 
> [  556.946055] sd 2:0:0:0: [sda] Add. Sense: No additional sense information
> [  556.947290] sd 2:0:0:0: [sda] Sense Key : No Sense [current] 
> [  556.947298] sd 2:0:0:0: [sda] Add. Sense: No additional sense information
> [  556.948539] sd 2:0:0:0: [sda] Sense Key : No Sense [current] 
> [  556.948547] sd 2:0:0:0: [sda] Add. Sense: No additional sense information
> [  556.949790] sd 2:0:0:0: [sda] Sense Key : No Sense [current] 
> [  556.949798] sd 2:0:0:0: [sda] Add. Sense: No additional sense information
> [  556.951045] sd 2:0:0:0: [sda] Sense Key : No Sense [current] 
> [  556.951053] sd 2:0:0:0: [sda] Add. Sense: No additional sense information
> [  556.952290] sd 2:0:0:0: [sda] Sense Key : No Sense [current] 
> [  556.952297] sd 2:0:0:0: [sda] Add. Sense: No additional sense information
> [  556.954665] sd 2:0:0:0: [sda] Sense Key : No Sense [current] 
> [  556.954673] sd 2:0:0:0: [sda] Add. Sense: No additional sense information
> [  556.957665] sd 2:0:0:0: [sda] Sense Key : No Sense [current] 
> [  556.957673] sd 2:0:0:0: [sda] Add. Sense: No additional sense information
> [  556.960791] sd 2:0:0:0: [sda] Sense Key : No Sense [current] 
> [  556.960799] sd 2:0:0:0: [sda] Add. Sense: No additional sense information
> [  556.963790] sd 2:0:0:0: [sda] Sense Key : No Sense [current] 
> [  556.963798] sd 2:0:0:0: [sda] Add. Sense: No additional sense information
> [  556.966915] sd 2:0:0:0: [sda] Sense Key : No Sense [current] 
> 
> These repeat forever, till I disconnect.
> 
> Regards,
> Luciano Rocha
> 


