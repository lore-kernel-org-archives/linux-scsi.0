From: Fabien Salvi <fabien@cri74.org>
Subject: Re: qlogic and FC to SCSI bridge
Date: Mon, 30 Sep 2002 12:09:12 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D9822C8.C24FAD86@cri74.org>
References: <3D94DB64.C230016@rentapacs.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Michael Ulbrich <mul@rentapacs.de>
Cc: linux-scsi@vger.kernel.org

Michael Ulbrich wrote:
> 
> Hi all,
> 
> I'm trying to use a Compaq Fibre Channel Tape Controller II as a FC to
> SCSI bridge assuming that it provides general SCSI bridging
> functionality and is not limited (as the name might imply) to SCSI
> tape devices. The FCTC has two wide differential SCSI busses. For
> testing purposes I connected one harddisk to one of the busses.
> 
> The host bus adapter is a qlogic 2100 in a linux box running RH 7.3 with
> the Qlogic driver qla2xxx updated to version 6.1b5 - to my knowledge the
> latest version from qlogic.
> 
> During boot the qla ROM BIOS detects the device connected to the FCTC:
> 
> > QLogic Corporation
> > QLA2000,QLA2100 PCI Fibre Channel ROM BIOS Version 1.37
> > ...
> >
> > Press <ALT-Q> for Fast!UTIL
> >
> > ISP2000/2100 Firmware Version 1.15.37
> > QLogic Adapter isung IRQ number 10
> >
> > Device Device Adapter Loop Loop Vendor    Product    Product
> > Number Type   Number   ID  LUN    ID        ID       Revision
> >  82   Disk     0      125  7    Quantum   XP34361WD  HP10
> 
> Booting with qla2100.o version 6.1b5 gives the following result:
> 

> [...]

> 
> In both cases the device attached to the SCSI bridge is not recognized
> by the qlogic driver. The older driver gives obviously some additional
> (debugging?) output. The kernel is configured with
> CONFIG_SCSI_MULTI_LUN=y.
> 
> Maybe someone on this list knows what I'm doing wrong or can give some
> hints in which direction to proceed. Any ideas that might help are
> greatly appreciated.

Hello,

Maybe it's a problem about lun scaning...
Your SCSI disk seems to use luns > 0

Try using this script (Rescan SCSI bus) :
http://www.garloff.de/kurt/linux/rescan-scsi-bus.sh

(use option -l to scan all luns)

from Kurt Garloff page :
http://www.garloff.de/kurt/linux/
 
Good luck !

-------------
Fabien SALVI      Centre de Ressources Informatiques
                  Archamps, France -- http://www.cri74.org
                  PingOO GNU/linux distribution : http://www.pingoo.org
