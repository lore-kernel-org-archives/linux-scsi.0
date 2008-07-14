From: Arkadiusz Miskiewicz <arekm@maven.pl>
Subject: Re: adaptec 3405 + 4 sas disks: synchronize_callback: synchronize failed, status = 226
Date: Mon, 14 Jul 2008 13:45:15 +0200
Message-ID: <200807141345.16305.arekm@maven.pl>
References: <200807140809.19937.arekm@maven.pl> <C9E18FB9-75B1-4768-B290-2E3C9370D68D@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailmxout.mailmx.agnat.pl ([193.239.44.238]:49417 "EHLO
	mailmxout.mailmx.agnat.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984AbYGNLpV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Jul 2008 07:45:21 -0400
In-Reply-To: <C9E18FB9-75B1-4768-B290-2E3C9370D68D@adaptec.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Salyzyn <Mark_Salyzyn@adaptec.com>
Cc: Linux-Scsi <linux-scsi@vger.kernel.org>, AACRAID <AACRAID@adaptec.com>, Achim Leubner <Achim_Leubner@adaptec.com>

On Monday 14 July 2008, Mark Salyzyn wrote:
> 226 means CT_ERROR, a generic response to the CT_FLUSH_CACHE command
> to the controller when the action could not be performed.
>
> The action is to flush all the controller's cache to the targets in
> response to a SCSI SYNCHRONIZE_CACHE command. I expect that you are
> running with a degraded array, or incompatible drives?

It's in "Optimal" state and I have no idea which drives are "incompatib=
le". =20
Is this list published somewhere (I was looking at 3405 download sectio=
n at=20
adaptec.com)?

# ./arcconf64 getconfig 1 al
Controllers found: 1
----------------------------------------------------------------------
Controller information
----------------------------------------------------------------------
   Controller Status                        : Optimal
   Channel description                      : SAS/SATA
   Controller Model                         : Adaptec 3405
   Controller Serial Number                 : 8C0210064E7
   Temperature                              : 46 C/ 114 F (Normal)
   Installed memory                         : 128 MB
   Copyback                                 : Disabled
   Background consistency check             : Disabled
   Automatic Failover                       : Enabled
   Global task priority                     : High
   Defunct disk drive count                 : 0
   Logical devices/Failed/Degraded          : 1/0/0
   --------------------------------------------------------
   Controller Version Information
   --------------------------------------------------------
   BIOS                                     : 5.2-0 (15728)
   Firmware                                 : 5.2-0 (15728)
   Driver                                   : 1.1-5 (2449)
   Boot Flash                               : 5.2-0 (15728)
   --------------------------------------------------------
   Controller Battery Information
   --------------------------------------------------------
   Status                                   : Optimal
   Over temperature                         : No
   Capacity remaining                       : 99 percent
   Time remaining (at current draw)         : 3 days, 1 hours, 11 minut=
es

----------------------------------------------------------------------
Logical device information
----------------------------------------------------------------------
Logical device number 0
   Logical device name                      : RAID
   RAID level                               : 10
   Status of logical device                 : Optimal
   Size                                     : 571392 MB
   Stripe-unit size                         : 256 KB
   Read-cache mode                          : Enabled
   Write-cache mode                         : Enabled (write-back)
   Write-cache setting                      : Enabled (write-back) when=
=20
protected by battery
   Partitioned                              : Yes
   Protected by Hot-Spare                   : No
   Bootable                                 : Yes
   Failed stripes                           : No
   --------------------------------------------------------
   Logical device segment information
   --------------------------------------------------------
   Group 0, Segment 0                       : Present (0,0)=20
3LM4DRD200009842S4XD
   Group 0, Segment 1                       : Present (0,1)=20
3LM4DRDZ00009842RNGC
   Group 1, Segment 0                       : Present (0,2)=20
3LM4DS0P00009808RMV7
   Group 1, Segment 1                       : Present (0,3)=20
3LM48ABH00009842SXEE


----------------------------------------------------------------------
Physical Device information
----------------------------------------------------------------------
      Device #0
         Device is a Hard drive
         State                              : Online
         Supported                          : Yes
         Transfer Speed                     : SAS 3.0 Gb/s
         Reported Channel,Device            : 0,0
         Reported Location                  : Enclosure 0, Slot 0
         Reported ESD                       : 2,0
         Vendor                             : SEAGATE
         Model                              : ST3300655SS
         Firmware                           : 0002
         Serial number                      : 3LM4DRD200009842S4XD
         World-wide name                    : 5000C5000A4B3558
         Size                               : 286102 MB
         Write Cache                        : Enabled (write-back)
         FRU                                : None
         S.M.A.R.T.                         : No
      Device #1
         Device is a Hard drive
         State                              : Online
         Supported                          : Yes
         Transfer Speed                     : SAS 3.0 Gb/s
         Reported Channel,Device            : 0,1
         Reported Location                  : Enclosure 0, Slot 1
         Reported ESD                       : 2,0
         Vendor                             : SEAGATE
         Model                              : ST3300655SS
         Firmware                           : 0002
         Serial number                      : 3LM4DRDZ00009842RNGC
         World-wide name                    : 5000C5000A4B3800
         Size                               : 286102 MB
         Write Cache                        : Enabled (write-back)
         FRU                                : None
         S.M.A.R.T.                         : No
      Device #2
         Device is a Hard drive
         State                              : Online
         Supported                          : Yes
         Transfer Speed                     : SAS 3.0 Gb/s
         Reported Channel,Device            : 0,2
         Reported Location                  : Enclosure 0, Slot 2
         Reported ESD                       : 2,0
         Vendor                             : SEAGATE
         Model                              : ST3300655SS
         Firmware                           : 0002
         Serial number                      : 3LM4DS0P00009808RMV7
         World-wide name                    : 5000C5000A4B3074
         Size                               : 286102 MB
         Write Cache                        : Enabled (write-back)
         FRU                                : None
         S.M.A.R.T.                         : No
      Device #3
         Device is a Hard drive
         State                              : Online
         Supported                          : Yes
         Transfer Speed                     : SAS 3.0 Gb/s
         Reported Channel,Device            : 0,3
         Reported Location                  : Enclosure 0, Slot 3
         Reported ESD                       : 2,0
         Vendor                             : SEAGATE
         Model                              : ST3300655SS
         Firmware                           : 0002
         Serial number                      : 3LM48ABH00009842SXEE
         World-wide name                    : 5000C5000A4B39B4
         Size                               : 286102 MB
         Write Cache                        : Enabled (write-back)
         FRU                                : None
         S.M.A.R.T.                         : No
      Device #4
         Device is an Enclosure services device
         Reported Channel,Device            : 2,0
         Enclosure ID                       : 0
         Type                               : SES2
         Vendor                             : ADAPTEC
         Model                              : Virtual SGPIO  0
         Firmware                           : 0001
         Status of Enclosure services device
            Temperature                     : Normal


Command completed successfully.



>
> Make sure your drive and controller firmware is as up-to-date as
> possible.

Controller firmware is up to date.  Disks firmware is 002 according to=20
arcconf, unfortunately seagate doesn't seem to publish firmware on thei=
r=20
site, so I don't know if it's old or new.

>
> Sincerely -- Mark Salyzyn
>
> On Jul 14, 2008, at 2:09 AM, Arkadiusz Miskiewicz wrote:
> > Hello,
> >
> > I'm running 2.6.24.3 kernel and I'm getting few error messages
> > comming from
> > aacraid driver. Hardware is adaptec 3405 running firmware 15728 + 4
> > SAS 300GB
> > harddisks configured in single raid10 array.
> >
> > [167674.161866] synchronize_callback: synchronize failed, status =3D=
 226
> > [168977.738031] synchronize_callback: synchronize failed, status =3D=
 226
> > [172180.752140] synchronize_callback: synchronize failed, status =3D=
 226
> > [177494.855145] synchronize_callback: synchronize failed, status =3D=
 226
> > [189594.477223] synchronize_callback: synchronize failed, status =3D=
 226
> > [191411.881236] synchronize_callback: synchronize failed, status =3D=
 226
> > [217130.596663] synchronize_callback: synchronize failed, status =3D=
 226
> > [219236.032362] synchronize_callback: synchronize failed, status =3D=
 226
> >
> > What does 226 mean and what does it indicate (serious problem?) ?
> >
> > ps. would be good if prefix was added to these messages to know
> > where these
> > come from
> > --
> > Arkadiusz Mi=C5=9Bkiewicz        PLD/Linux Team
> > arekm / maven.pl            http://ftp.pld-linux.org/



--=20
Arkadiusz Mi=C5=9Bkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
