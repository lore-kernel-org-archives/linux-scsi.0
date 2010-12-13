From: Luben Tuikov <ltuikov@yahoo.com>
Subject: [ANNOUNCE] UAS uasp.c driver available on github
Date: Mon, 13 Dec 2010 13:14:31 -0800 (PST)
Message-ID: <150741.23411.qm@web31808.mail.mud.yahoo.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The uasp.c driver is available on github at https://github.com/ltuikov/=
linux-2.6. The free-linux branch is a branch off of the master branch. =
The free-linux branch contains the following:

 * uasp.c driver which allows you to connect to USB Attached SCSI (UAS)=
 devices and use them as SCSI devices.

The free-linux branch also includes the following patches:

 * 6e5eba [USB] Use normalized sense when emulating autosense,
 * 245423 [SCSI] Retrieve the Caching mode page, and
 * 67869f [BLOCK] Preliminary increasing tag sequence implementation.

The first two of those patches, 6e5eba and 245423, have been accepted i=
nto topic branches and should be merged in the next (or current) kernel=
 release.

The 67869f patch is needed to eliminate TMF processing race conditions =
in case of multiple application clients issuing commands to the same I_=
T nexus as I described here: http://marc.info/?t=3D128902350400001&r=3D=
1&w=3D2.

=A0 =A0 Luben
