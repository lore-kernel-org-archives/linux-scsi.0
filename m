From: pinco pallino <pinc_o@yahoo.it>
Subject: WAS: "Re: [Bugme-new] [Bug 11302] New: I get a kernel OOPS! If I try to attach an usb card reader, SD, MMC, ecc.. to my Slamd64"
Date: Mon, 1 Sep 2008 23:30:56 +0000 (GMT)
Message-ID: <8635.97645.qm@web27302.mail.ukl.yahoo.com>
References: <20080810233352.8423614f.akpm@linux-foundation.org>
Reply-To: pinc_o@yahoo.it
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web27302.mail.ukl.yahoo.com ([217.146.177.163]:33806 "HELO
	web27302.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751541AbYIAXa7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Sep 2008 19:30:59 -0400
In-Reply-To: <20080810233352.8423614f.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Pierre Ossman <drzeus@drzeus.cx>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-scsi@vger.kernel.org, bugme-daemon@bugzilla.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>

Hi Andrew,

with the new kernel 2.6.26.3 the SD are now read and wrote correctly, b=
ut SDHC are not read! The kernel repeat the error. Follow the error:

Sep  1 22:08:20 athos -- MARK --
Sep  1 22:19:12 athos kernel: usb 1-6: new high speed USB device using =
ehci_hcd and address 5
Sep  1 22:19:12 athos kernel: usb 1-6: configuration #1 chosen from 1 c=
hoice
Sep  1 22:19:12 athos kernel: scsi5 : SCSI emulation for USB Mass Stora=
ge devices
Sep  1 22:19:17 athos kernel: scsi 5:0:0:0: Direct-Access     Generic  =
USB SD Reader    1.00 PQ: 0 ANSI: 0
Sep  1 22:19:47 athos kernel: usb 1-6: reset high speed USB device usin=
g ehci_hcd and address 5
Sep  1 22:20:14 athos last message repeated 3 times
Sep  1 22:20:14 athos kernel: sd 5:0:0:0: Device offlined - not ready a=
fter error recovery
Sep  1 22:20:14 athos kernel: usb 1-6: USB disconnect, address 5
Sep  1 22:20:14 athos kernel: sd 5:0:0:0: [sdd] READ CAPACITY failed
Sep  1 22:20:14 athos kernel: sd 5:0:0:0: [sdd] Result: hostbyte=3D0x01=
 driverbyte=3D0x00
Sep  1 22:20:14 athos kernel: sd 5:0:0:0: [sdd] Sense not available.
Sep  1 22:20:14 athos kernel: sd 5:0:0:0: [sdd] Write Protect is off
Sep  1 22:20:14 athos kernel: sd 5:0:0:0: [sdd] Attached SCSI removable=
 disk
Sep  1 22:20:14 athos kernel: sd 5:0:0:0: Attached scsi generic sg3 typ=
e 0
Sep  1 22:20:14 athos kernel: usb 1-6: new high speed USB device using =
ehci_hcd and address 6
Sep  1 22:20:14 athos kernel: usb 1-6: configuration #1 chosen from 1 c=
hoice
Sep  1 22:20:14 athos kernel: scsi6 : SCSI emulation for USB Mass Stora=
ge devices
Sep  1 22:20:19 athos kernel: scsi 6:0:0:0: Direct-Access     Generic  =
USB SD Reader    1.00 PQ: 0 ANSI: 0
Sep  1 22:20:49 athos kernel: usb 1-6: reset high speed USB device usin=
g ehci_hcd and address 6
Sep  1 22:20:59 athos kernel: usb 1-6: reset high speed USB device usin=
g ehci_hcd and address 6
Sep  1 22:21:00 athos kernel: usb 1-6: USB disconnect, address 6
Sep  1 22:21:00 athos kernel: sd 6:0:0:0: Device offlined - not ready a=
fter error recovery
Sep  1 22:21:00 athos kernel: sd 6:0:0:0: [sdd] READ CAPACITY failed
Sep  1 22:21:00 athos kernel: sd 6:0:0:0: [sdd] Result: hostbyte=3D0x01=
 driverbyte=3D0x00
Sep  1 22:21:00 athos kernel: sd 6:0:0:0: [sdd] Sense not available.
Sep  1 22:21:00 athos kernel: sd 6:0:0:0: [sdd] Write Protect is off
Sep  1 22:21:00 athos kernel: sd 6:0:0:0: [sdd] Attached SCSI removable=
 disk
Sep  1 22:21:00 athos kernel: sd 6:0:0:0: Attached scsi generic sg3 typ=
e 0
Sep  1 22:21:00 athos kernel: usb 1-6: new high speed USB device using =
ehci_hcd and address 7
Sep  1 22:21:00 athos kernel: usb 1-6: configuration #1 chosen from 1 c=
hoice
Sep  1 22:21:00 athos kernel: scsi7 : SCSI emulation for USB Mass Stora=
ge devices
Sep  1 22:21:05 athos kernel: scsi 7:0:0:0: Direct-Access     Generic  =
USB SD Reader    1.00 PQ: 0 ANSI: 0
Sep  1 22:21:35 athos kernel: usb 1-6: reset high speed USB device usin=
g ehci_hcd and address 7
Sep  1 22:21:36 athos kernel: usb 1-6: USB disconnect, address 7
Sep  1 22:21:36 athos kernel: sd 7:0:0:0: Device offlined - not ready a=
fter error recovery
Sep  1 22:21:36 athos kernel: sd 7:0:0:0: [sdd] READ CAPACITY failed
Sep  1 22:21:36 athos kernel: sd 7:0:0:0: [sdd] Result: hostbyte=3D0x01=
 driverbyte=3D0x00
Sep  1 22:21:36 athos kernel: sd 7:0:0:0: [sdd] Sense not available.
Sep  1 22:21:36 athos kernel: sd 7:0:0:0: [sdd] Write Protect is off
Sep  1 22:21:36 athos kernel: sd 7:0:0:0: [sdd] Attached SCSI removable=
 disk
Sep  1 22:21:36 athos kernel: sd 7:0:0:0: Attached scsi generic sg3 typ=
e 0
Sep  1 22:22:00 athos kernel: usb 1-6: new high speed USB device using =
ehci_hcd and address 8
Sep  1 22:22:00 athos kernel: usb 1-6: configuration #1 chosen from 1 c=
hoice
Sep  1 22:22:00 athos kernel: scsi8 : SCSI emulation for USB Mass Stora=
ge devices
Sep  1 22:22:05 athos kernel: scsi 8:0:0:0: Direct-Access     Generic  =
USB SD Reader    1.00 PQ: 0 ANSI: 0
Sep  1 22:22:27 athos kernel: sd 8:0:0:0: [sdd] READ CAPACITY failed
Sep  1 22:22:27 athos kernel: sd 8:0:0:0: [sdd] Result: hostbyte=3D0x07=
 driverbyte=3D0x00
Sep  1 22:22:27 athos kernel: sd 8:0:0:0: [sdd] Sense not available.
Sep  1 22:22:27 athos kernel: sd 8:0:0:0: [sdd] Write Protect is off
Sep  1 22:22:28 athos kernel: sd 8:0:0:0: [sdd] Attached SCSI removable=
 disk
Sep  1 22:22:28 athos kernel: sd 8:0:0:0: Attached scsi generic sg3 typ=
e 0
Sep  1 22:22:28 athos kernel: usb 1-6: USB disconnect, address 8
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

I hope this is useful to you and to us! :)

Best Regards

Paolo

P.S. Please, excuse me for my Bad English!


--- Lun 11/8/08, Andrew Morton <akpm@linux-foundation.org> ha scritto:

> Da: Andrew Morton <akpm@linux-foundation.org>
> Oggetto: Re: [Bugme-new] [Bug 11302] New: I get a kernel OOPS! If I t=
ry to attach an usb card reader, SD, MMC, ecc.. to my Slamd64
> A: "Pierre Ossman" <drzeus@drzeus.cx>
> Cc: linux-scsi@vger.kernel.org, bugme-daemon@bugzilla.kernel.org, pin=
c_o@yahoo.it, "James Bottomley" <James.Bottomley@HansenPartnership.com>
> Data: Luned=EC 11 agosto 2008, 08:33
> On Mon, 11 Aug 2008 07:45:53 +0200 Pierre Ossman
> <drzeus@drzeus.cx> wrote:
>=20
> > On Sun, 10 Aug 2008 13:53:44 -0700
> > Andrew Morton <akpm@linux-foundation.org> wrote:
> >=20
> > >=20
> > > (switched to email.  Please respond via emailed
> reply-to-all, not via the
> > > bugzilla web interface).
> > >=20
> > > On Sun, 10 Aug 2008 13:45:49 -0700 (PDT)
> bugme-daemon@bugzilla.kernel.org wrote:
> > >=20
> > > >
> http://bugzilla.kernel.org/show_bug.cgi?id=3D11302
> > > >=20
> > > >            Summary: I get a kernel OOPS! If
> I try to attach an usb card
> > > >                     reader, SD, MMC, ecc..
> to my Slamd64
> > > >            Product: IO/Storage
> > > >            Version: 2.5
> > > >      KernelVersion: 2.6.26.2
> > > >           Platform: All
> > > >         OS/Version: Linux
> > > >               Tree: Mainline
> > > >             Status: NEW
> > > >           Severity: blocking
> > > >           Priority: P1
> > > >          Component: SCSI
> > > >         AssignedTo:
> linux-scsi@vger.kernel.org
> > > >         ReportedBy: pinc_o@yahoo.it
> > >=20
> > > Is this a scsi regresion, or an mmc regression?
> > >=20
>=20
> OK.  There have been some regressions in the scsi area but
> I thought
> that a) they were fixed and b) none manifested as an oops
> in
> slave_alloc().
>=20
> Perhaps James can take a look please?
>=20
> > There are no USB based "real" MMC
> controllers, so I'd say SCSI.
> >=20
> > > > If attach my usb card reader, without load
> mmc_block an mmc_core modules, then
> > > > the follow OOPS appear(If first load them,
> simply doesn't mount the SD. Please
> > > > note: I always use "automatic loading
> kernel modules" compiled in "my" kernelS.
> > > > But from many time, the recent kernelS not
> load the mmc_block module):
> >=20
> > I don't know what kind of weird ass scripts loaded
> them for USB mass
> > storage to begin with. As for the claimed lack of
> crashes when loaded;
> > no idea as there is no interaction between the SCSI
> and MMC layer.
> >=20
> > > > Modules linked in: nvidia(P) [last unloaded:
> nvidia]
> >=20
> > This is always a good start..
>=20
> I very much doubt it.
>=20
> Paolo, can you please check to see if the crash happens in
> a kernel
> into which the nvidia driver has never been loaded?

__________________________________________________
Do You Yahoo!?
Poco spazio e tanto spam? Yahoo! Mail ti protegge dallo spam e ti da ta=
nto spazio gratuito per i tuoi file e i messaggi=20
http://mail.yahoo.it=20
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
