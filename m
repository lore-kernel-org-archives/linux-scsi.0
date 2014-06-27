From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
Subject: Re: External USB3 disk fails with "Invalid field in cdb"
Date: Fri, 27 Jun 2014 20:51:53 +0200
Message-ID: <20140627205153.6a8ac916@wiggum>
References: <20140627195503.49e2dc55@wiggum>
 <Pine.LNX.4.44L0.1406271440130.875-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/cPaG66xLJMU4ar09cCiN2v0"; protocol="application/pgp-signature"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:49698 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862AbaF0Syg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jun 2014 14:54:36 -0400
In-Reply-To: <Pine.LNX.4.44L0.1406271440130.875-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "Bryn M. Reeves" <bmr@redhat.com>, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net

--Sig_/cPaG66xLJMU4ar09cCiN2v0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 27 Jun 2014 14:42:01 -0400 (EDT)
Alan Stern <stern@rowland.harvard.edu> wrote:

> Michael, can you post the "lsusb -v" output for this device?  I see it=20
> is made by JMicron; they are notorious for buggy USB-ATA bridges.

Of course. Here you go:

Bus 004 Device 009: ID 152d:0567 JMicron Technology Corp. / JMicron USA Tec=
hnology Corp.=20
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               3.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0=20
  bDeviceProtocol         0=20
  bMaxPacketSize0         9
  idVendor           0x152d JMicron Technology Corp. / JMicron USA Technolo=
gy Corp.
  idProduct          0x0567=20
  bcdDevice            1.14
  iManufacturer           1 JMicron
  iProduct                2 USB to ATA/ATAPI Bridge
  iSerial                 3 xxx
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength          121
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          4 USB Mass Storage
    bmAttributes         0xc0
      Self Powered
    MaxPower                2mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass         8 Mass Storage
      bInterfaceSubClass      6 SCSI
      bInterfaceProtocol     80 Bulk-Only
      iInterface              6 MSC Bulk-Only Transport
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0400  1x 1024 bytes
        bInterval               0
        bMaxBurst              15
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0400  1x 1024 bytes
        bInterval               0
        bMaxBurst              15
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       1
      bNumEndpoints           4
      bInterfaceClass         8 Mass Storage
      bInterfaceSubClass      6 SCSI
      bInterfaceProtocol     98=20
      iInterface             10 MSC USB Attached SCSI
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x01  EP 1 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0400  1x 1024 bytes
        bInterval               0
        bMaxBurst               0
        Command pipe (0x01)
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0400  1x 1024 bytes
        bInterval               0
        bMaxBurst               0
        MaxStreams             16
        Status pipe (0x02)
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0400  1x 1024 bytes
        bInterval               0
        bMaxBurst              15
        MaxStreams             16
        Data-in pipe (0x03)
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x04  EP 4 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0400  1x 1024 bytes
        bInterval               0
        bMaxBurst              15
        MaxStreams             16
        Data-out pipe (0x04)
Binary Object Store Descriptor:
  bLength                 5
  bDescriptorType        15
  wTotalLength           22
  bNumDeviceCaps          2
  USB 2.0 Extension Device Capability:
    bLength                 7
    bDescriptorType        16
    bDevCapabilityType      2
    bmAttributes   0x00000002
      Link Power Management (LPM) Supported
  SuperSpeed USB Device Capability:
    bLength                10
    bDescriptorType        16
    bDevCapabilityType      3
    bmAttributes         0x00
    wSpeedsSupported   0x000e
      Device can operate at Full Speed (12Mbps)
      Device can operate at High Speed (480Mbps)
      Device can operate at SuperSpeed (5Gbps)
    bFunctionalitySupport   1
      Lowest fully-functional device speed is Full Speed (12Mbps)
    bU1DevExitLat          10 micro seconds
    bU2DevExitLat          32 micro seconds
Device Status:     0x000d
  Self Powered
  U1 Enabled
  U2 Enabled



MaxPower=3D2mA is a nice guess for a hard disk. ;)

--=20
Michael

--Sig_/cPaG66xLJMU4ar09cCiN2v0
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTrb1JAAoJEPUyvh2QjYsONhUP/jTMjzJhF17En149DAeussxK
mr/d9owtLKr0GP0H4tfNq3T47lwF+XFN+rBVlF5oO9P44YudVCLyGgDGFQJDWAPk
fHLaHQIPAcL4Mtds4DvDTWbejonLpF9pmeImfFjGQwqK2afa72uhVhb/CQtIVLHK
1rKxtp2ZRBoG6IbLo1CSWembLQ6PhuFdZQsz6+PLB1869f+Uc3d8jw82reP3JUHA
fDZ0FhHo0C3I6jXVhY+/ITjwKCnWpZHdwoVm3xiakM+/ys79f3nUqpyhjm75ohCU
Ky5rqz5e9wZAoPyP7ezWK/0Ldt9W9K6JE5bHOfgxVFE4pc43tMl8trPzCxlg8Lhq
GxtzM0QSDp+sqxC2CciNK1bcsKAEJiBNZRdZ2eOW2t1iP1V3R7i7Dkq+RhCqUJj9
w5FBO35XgMrd6egi8C6+F/Yo261XjBVae3m3VN0aCPRegpiqhpQfoKa81dFUghvG
j8IgQS1GaaBFoEvZQ7p4GltVSgNfg6KFGohzLwDbDrWE8SzJq+zwHqQb8rdrmOwU
x2WvRh8X8588WmahcHi/YViBmDazH3S6tH+Yk1XkwhEakw98I/w1gCnQD4ltMSK8
QEzkCVlBNWDOnJUDBQKLNyjd8DMLbossRMNCmauzOVOvIwbIF/xJA+jcd6gdQBZp
Gs47rJ26F4GbfLbGQT1G
=0J5I
-----END PGP SIGNATURE-----

--Sig_/cPaG66xLJMU4ar09cCiN2v0--
