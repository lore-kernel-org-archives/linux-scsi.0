From: Patrick Mochel <mochel@osdl.org>
Subject: Re: [PATCH] /proc/scsi/map
Date: Tue, 25 Jun 2002 11:13:15 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.33.0206250949300.8496-100000@geena.pdx.osdl.net>
References: <3D14D301.F2C8DBBE@torque.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3D14D301.F2C8DBBE@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: Linux kernel list <linux-kernel@vger.kernel.org>, Linux SCSI list <linux-scsi@vger.kernel.org>


> So the "target id" we put in driverfs could have one of
> these suggested formats:
>    <number>              - 0 to 1 for ATA
>    <number>              - 0 to 15 for SCSI parallel interface
>    <number>              - 24 bit number for fibre channel
>    <EUI 64+discovery_id> - ieee1394
>    <???>                 - usb (mass storage + scanner)
>    <WWUI> ":" <num>      - iSCSI   [something better than ":"?]

In the physical device tree, what's wrong with setting the name to 
something simple, like 'iscsi0', etc. All you're looking for is 
a locally unique ID. 

You need a globally unique ID to do persitant attribute setting and 
restoration, including naming. When /sinb/hotplug gets a call to name the 
device, it can look up the GUID to determine what to name the device.

	-pat

