From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
Subject: Re: Performance issues with Areca 1680 SAS Controllers
Date: Thu, 20 Aug 2009 12:56:04 +0300
Message-ID: <20090820095604.GT19938@edu.joroinen.fi>
References: <20090819140848.GW19938@edu.joroinen.fi> <SERVER-ARECA8ldpyzy000025bc@areca.com.tw>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from edu.joroinen.fi ([194.89.68.130]:50999 "EHLO edu.joroinen.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752640AbZHTJ4E (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Aug 2009 05:56:04 -0400
Content-Disposition: inline
In-Reply-To: <SERVER-ARECA8ldpyzy000025bc@areca.com.tw>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nick Cheng <nick.cheng@areca.com.tw>
Cc: 'Andrew Morton' <akpm@linux-foundation.org>, 'Michael Fuckner' <michael@fuckner.net>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, Aug 20, 2009 at 09:54:27AM +0800, Nick Cheng wrote:
> Hi Gentlemen,
> We have worked it out with new firmware and driver.
> You can download the latest F/W from
> ftp://ftp.areca.com.tw/RaidCards/BIOS_Firmware/ARC1680/ and use the a=
ttached
> driver.
> Please have a try.
> Any comments are welcome.

Thanks! I'll give it a try today and report back.

-- Pasi

> Thank you,
> -----Original Message-----
> From: Pasi K=E4rkk=E4inen [mailto:pasik@iki.fi]=20
> Sent: Wednesday, August 19, 2009 10:09 PM
> To: Nick Cheng
> Cc: 'Andrew Morton'; 'Michael Fuckner'; linux-kernel@vger.kernel.org;
> linux-scsi@vger.kernel.org; 'Erich Chen'
> Subject: Re: Performance issues with Areca 1680 SAS Controllers
>=20
> On Thu, Nov 20, 2008 at 03:39:40PM +0800, Nick Cheng wrote:
> > Hi Michael,
> > I will get around handling your issue.
> > Thanks for your kindly patience,
> >=20
>=20
> Hello,
>=20
> Was this issue resolved? I'm seeing similar behaviour.. I think it's =
related
> to flushing the controller cache?
>=20
> Waiting a while (after the disk leds stop blinking) performance is ba=
ck to
> normal..=20
>=20
> -- Pasi
>=20
> > -----Original Message-----
> > From: Andrew Morton [mailto:akpm@linux-foundation.org]=20
> > Sent: Thursday, November 20, 2008 9:18 AM
> > To: Michael Fuckner
> > Cc: linux-kernel@vger.kernel.org; linux-scsi@vger.kernel.org; Nick =
Cheng;
> > Erich Chen
> > Subject: Re: Performance issues with Areca 1680 SAS Controllers
> >=20
> > (cc's added)
> >=20
> > On Wed, 19 Nov 2008 13:16:56 +0100
> > Michael Fuckner <michael@fuckner.net> wrote:
> >=20
> > > Hi,
> > >=20
> > > I am using an Areca 1680-SAS-Controller with 16 SAS-HDD (Seagate =
1TB
> > > ST31000640SS). I set up a Raid6 with all 16 disks and formatted i=
t with
> > > XFS. The Controller has 512MB RAM and a BBU. The OS is installed =
to
> > > another disk attached to the onboard AHCI controller.
> > >=20
> > > After doing some IO, the areca raidset is slower compared to the =
rate=20
> > > directly
> > > after boot.
> > >=20
> > >=20
> > > [root@storage ~]# dd if=3D/dev/sdb1 of=3D/dev/null bs=3D1M count=3D=
50k
> > iflag=3Ddirect
> > > 51200+0 records in
> > > 51200+0 records out
> > > 53687091200 bytes (54 GB) copied, 59.6494 seconds, 900 MB/s
> > > [root@storage ~]# mount /dev/sdb1 /data
> > > [root@storage ~]# cd /data/
> > > [root@storage data]# ./iozone -i 0 -i 1 -s 32g -r 16m -S 6144 -t =
8 -+r
> > > -o  >raid6_sync_t8.log
> > > [root@storage data]# cd
> > > [root@storage ~]# umount /data/
> > > [root@storage ~]# dd if=3D/dev/sdb1 of=3D/dev/null bs=3D1M count=3D=
50k
> > iflag=3Ddirect
> > > 51200+0 records in
> > > 51200+0 records out
> > > 53687091200 bytes (54 GB) copied, 76.4036 seconds, 703 MB/s
> > >=20
> > > I tested different Versions of Linux (Centos 5.2, OpenSUSE 11, De=
bian
> > > Lenny) and Vanilla kernels 2.6.22-2.6.27, all show this behaviour=
=2E
> > >=20
> > > Idea why the device slows down after IO- or better: how to keep t=
he high
> > > rate? Is this reproducible foer Areca SATA Controllers (Type 11XX=
 and
> > 12XX)
> > >=20
> > > Regards,
> > >    Michael!
> >=20
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ker=
nel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
