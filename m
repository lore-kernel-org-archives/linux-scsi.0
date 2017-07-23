From: Wolfgang Schnitker <wolfgang.schnitker@gmx.de>
Subject: mvsas driver missing PCI-IDs on ASUS Mobo
Date: Sun, 23 Jul 2017 13:50:52 +0200
Message-ID: <2eefea17-b7a4-ff99-fb23-3f41f95bc701@gmx.de>
Mime-Version: 1.0
Content-Type: multipart/alternative;
 boundary="------------DA52CC682FF0394B8F39A32D"
Return-path: <bounce-debian-kernel=glddk-debian-kernel=m.gmane.org@lists.debian.org>
Resent-Message-ID: <jSeJ9S-3nPK.A.g6G.z2IdZB@bendel>
List-URL: <https://lists.debian.org/debian-kernel/>
List-Post: <mailto:debian-kernel@lists.debian.org>
List-Help: <mailto:debian-kernel-request@lists.debian.org?subject=help>
List-Subscribe: <mailto:debian-kernel-request@lists.debian.org?subject=subscribe>
List-Unsubscribe: <mailto:debian-kernel-request@lists.debian.org?subject=unsubscribe>
List-Archive: https://lists.debian.org/msgid-search/2eefea17-b7a4-ff99-fb23-3f41f95bc701@gmx.de
To: JBottomley@parallels.com, taggart@debian.org, debian-kernel@lists.debian.org, linux-scsi@vger.kernel.org, ben@decadent.org.uk
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------DA52CC682FF0394B8F39A32D
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Dear SCSI Linux developers,

I have a machine with ASUS ([    0.000000] DMI: System manufacturer
System Product Name/P7H55-M/USB3, BIOS 1105    04/25/2011)

with a marvell SCSI chipset.

I am running Debian stretch amd64  (Linux winni2 4.9.0-3-amd64 #1 SMP
Debian 4.9.30-2+deb9u2 (2017-06-26) x86_64 GNU/Linux)


You can run Marvell  in IDE Mode, then the chipset will be reported as
an IDE Controller. PCI Id 1043:83ba / 1b4b:91a0

lspci -nnv -s 04:00.0
04:00.0 IDE interface [0101]: Marvell Technology Group Ltd. 88SE912x
SATA 6Gb/s Controller [IDE mode] [1b4b:91a0] (rev 12) (prog-if 8f
[Master SecP SecO PriP PriO])
    Subsystem: ASUSTeK Computer Inc. 88SE912x SATA 6Gb/s Controller [IDE
mode] [1043:83ba]
    Flags: bus master, fast devsel, latency 0, IRQ 32
    I/O ports at ec00 [size=3D8]
    I/O ports at e880 [size=3D4]
    I/O ports at e800 [size=3D8]
    I/O ports at e480 [size=3D4]
    I/O ports at e400 [size=3D16]
    Memory at f7fff000 (32-bit, non-prefetchable) [size=3D2K]
    Expansion ROM at f7fe0000 [disabled] [size=3D64K]
    Capabilities: [40] Power Management version 3
    Capabilities: [50] MSI: Enable+ Count=3D1/1 Maskable- 64bit-
    Capabilities: [70] Express Legacy Endpoint, MSI 00
    Capabilities: [100] Advanced Error Reporting
    Kernel driver in use: ahci
    Kernel modules: ahci, pata_marvell, ata_generic

You can run it as an AHCI device  PCI Id 1b4b:9120 and 1043:83ba

lspci -nnv -s 04:00.0
04:00.0 SATA controller [0106]: Marvell Technology Group Ltd. 88SE9120
SATA 6Gb/s Controller [1b4b:9120] (rev 12) (prog-if 01 [AHCI 1.0])
    Subsystem: ASUSTeK Computer Inc. 88SE9120 SATA 6Gb/s Controller
[1043:83ba]
    Flags: bus master, fast devsel, latency 0, IRQ 32
    I/O ports at ec00 [size=3D8]
    I/O ports at e880 [size=3D4]
    I/O ports at e800 [size=3D8]
    I/O ports at e480 [size=3D4]
    I/O ports at e400 [size=3D16]
    Memory at f7fff000 (32-bit, non-prefetchable) [size=3D2K]
    Expansion ROM at f7fe0000 [disabled] [size=3D64K]
    Capabilities: [40] Power Management version 3
    Capabilities: [50] MSI: Enable+ Count=3D1/1 Maskable- 64bit-
    Capabilities: [70] Express Legacy Endpoint, MSI 00
    Capabilities: [100] Advanced Error Reporting
    Kernel driver in use: ahci
    Kernel modules: ahci

=46rom my point of view at least the AHCI mode should be driven by the
mvsas driver.

Please add it to the marvell list of devices.

Thanks.

--=20
*Wolfgang Schnitker*
Beethovenstra=C3=9Fe 16
72535 Heroldstatt

--------------DA52CC682FF0394B8F39A32D
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: 8bit

<html>
  <head>

    <meta http-equiv="content-type" content="text/html; charset=utf-8">
  </head>
  <body bgcolor="#FFFFFF" text="#000000">
    <p>Dear SCSI Linux developers,</p>
    <p>I have a machine with ASUS ([    0.000000] DMI: System
      manufacturer System Product Name/P7H55-M/USB3, BIOS 1105   
      04/25/2011)</p>
    <p>with a marvell SCSI chipset.</p>
    <p>I am running Debian stretch amd64  (Linux winni2 4.9.0-3-amd64 #1
      SMP Debian 4.9.30-2+deb9u2 (2017-06-26) x86_64 GNU/Linux)</p>
    <p><br>
    </p>
    <p>You can run Marvell  in IDE Mode, then the chipset will be
      reported as an IDE Controller. PCI Id 1043:83ba / 1b4b:91a0<br>
    </p>
    <p>lspci -nnv -s 04:00.0<br>
      04:00.0 IDE interface [0101]: Marvell Technology Group Ltd.
      88SE912x SATA 6Gb/s Controller [IDE mode] [1b4b:91a0] (rev 12)
      (prog-if 8f [Master SecP SecO PriP PriO])<br>
          Subsystem: ASUSTeK Computer Inc. 88SE912x SATA 6Gb/s
      Controller [IDE mode] [1043:83ba]<br>
          Flags: bus master, fast devsel, latency 0, IRQ 32<br>
          I/O ports at ec00 [size=8]<br>
          I/O ports at e880 [size=4]<br>
          I/O ports at e800 [size=8]<br>
          I/O ports at e480 [size=4]<br>
          I/O ports at e400 [size=16]<br>
          Memory at f7fff000 (32-bit, non-prefetchable) [size=2K]<br>
          Expansion ROM at f7fe0000 [disabled] [size=64K]<br>
          Capabilities: [40] Power Management version 3<br>
          Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit-<br>
          Capabilities: [70] Express Legacy Endpoint, MSI 00<br>
          Capabilities: [100] Advanced Error Reporting<br>
          Kernel driver in use: ahci<br>
          Kernel modules: ahci, pata_marvell, ata_generic<br>
      <br>
    </p>
    You can run it as an AHCI device  PCI Id 1b4b:9120 and 1043:83ba<br>
    <br>
    lspci -nnv -s 04:00.0<br>
    04:00.0 SATA controller [0106]: Marvell Technology Group Ltd.
    88SE9120 SATA 6Gb/s Controller [1b4b:9120] (rev 12) (prog-if 01
    [AHCI 1.0])<br>
        Subsystem: ASUSTeK Computer Inc. 88SE9120 SATA 6Gb/s Controller
    [1043:83ba]<br>
        Flags: bus master, fast devsel, latency 0, IRQ 32<br>
        I/O ports at ec00 [size=8]<br>
        I/O ports at e880 [size=4]<br>
        I/O ports at e800 [size=8]<br>
        I/O ports at e480 [size=4]<br>
        I/O ports at e400 [size=16]<br>
        Memory at f7fff000 (32-bit, non-prefetchable) [size=2K]<br>
        Expansion ROM at f7fe0000 [disabled] [size=64K]<br>
        Capabilities: [40] Power Management version 3<br>
        Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit-<br>
        Capabilities: [70] Express Legacy Endpoint, MSI 00<br>
        Capabilities: [100] Advanced Error Reporting<br>
        Kernel driver in use: ahci<br>
        Kernel modules: ahci<br>
    <br>
    From my point of view at least the AHCI mode should be driven by the
    mvsas driver.<br>
    <br>
    Please add it to the marvell list of devices.<br>
    <br>
    Thanks.<br>
    <br>
    <div class="moz-signature">-- <br>
      <b>Wolfgang Schnitker</b><br>
      Beethovenstraße 16 <br>
      72535 Heroldstatt
    </div>
  </body>
</html>

--------------DA52CC682FF0394B8F39A32D--
