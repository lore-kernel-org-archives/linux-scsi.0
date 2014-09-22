From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [ANNOUNCE]: SCST 3.0 released
Date: Sun, 21 Sep 2014 21:28:50 -0700
Message-ID: <541FA582.5020900@vlnb.net>
References: <scr50ftb8lekn4h1of5mqdd9.1411196360032@email.android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <scr50ftb8lekn4h1of5mqdd9.1411196360032@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "scst.niko@gmail.com" <scst.niko@gmail.com>
Cc: scst-devel <scst-devel@lists.sourceforge.net>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

No, because it's too new, but you can always get it from the git. Or yo=
u=20
can use stable Emulex driver for 16Gb connectivity. It's not in the=20
bundle only because of the Emulex policy.

Thanks,
Vlad

On 9/19/2014 23:59, scst.niko@gmail.com wrote:
> Does 16Gb qla2x00t included?
>
> =E5=8F=91=E8=87=AA=E6=88=91=E7=9A=84=E5=B0=8F=E7=B1=B3=E6=89=8B=E6=9C=
=BA
>
> Vladislav Bolkhovitin <vst@vlnb.net>=E4=BA=8E 2014-9-20 =E4=B8=8B=E5=8D=
=882:39=E5=86=99=E9=81=93=EF=BC=9A
>
>     Hi All,
>
>     I'm glad to announce that SCST 3.0 has just been released. This
>     release includes SCST
>     core, target drivers iSCSI-SCST for iSCSI, including iSER support
>     (thanks to
>     Mellanox!), qla2x00t for QLogic Fibre Channel adapters, ib_srpt f=
or
>     InfiniBand SRP,
>     fcst for FCoE and scst_local for local loopback-like access as we=
ll
>     as SCST management
>     utility scstadmin. Also separately you can download from Emulex
>     development portal
>     stable and fully functional target driver for the current generat=
ion
>     of Emulex Fibre
>     Channel adapters.
>
>     SCST is alternative SCSI target stack for Linux. SCST allows
>     creation of sophisticated
>     storage devices, which provide advanced functionality, like
>     replication, thin
>     provisioning, deduplication, high availability, automatic backup,
>     etc. Majority of
>     recently developed SAN appliances, especially higher end ones, ar=
e
>     SCST based. It might
>     well be that your favorite storage appliance running SCST in the
>     firmware.
>
>     More info about SCST and its modules you can find on:
>     http://scst.sourceforge.net
>
>     Thanks to all who made it happen!
>
>     Vlad
