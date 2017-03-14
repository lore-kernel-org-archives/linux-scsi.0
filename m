From: Laurence Oberman <loberman@redhat.com>
Subject: Re: 4.10+ qla2xxx  driver wont load for qla2xxx (ISP2532-based 8Gb)
 with BAR 3 error, work fine on 4.9
Date: Mon, 13 Mar 2017 21:14:32 -0400 (EDT)
Message-ID: <1245811629.1625320.1489454072323.JavaMail.zimbra@redhat.com>
References: <718134298.971770.1489318763327.JavaMail.zimbra@redhat.com> <1431912146.999887.1489343453156.JavaMail.zimbra@redhat.com> <SN1PR0701MB18375C6A1D4D9255A9EFC60FF5250@SN1PR0701MB1837.namprd07.prod.outlook.com> <789950924.1470264.1489424052263.JavaMail.zimbra@redhat.com> <393057665.1624280.1489453598833.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx3-phx2.redhat.com ([209.132.183.24]:56878 "EHLO
        mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752053AbdCNBOe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Mar 2017 21:14:34 -0400
In-Reply-To: <393057665.1624280.1489453598833.JavaMail.zimbra@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <Himanshu.Madhani@cavium.com>
Cc: Chad Dupuis <Chad.Dupuis@cavium.com>, Linux SCSI List <linux-scsi@vger.kernel.org>



----- Original Message -----
> From: "Laurence Oberman" <loberman@redhat.com>
> To: "Himanshu Madhani" <Himanshu.Madhani@cavium.com>
> Cc: "Chad Dupuis" <Chad.Dupuis@cavium.com>, "Linux SCSI List" <linux-scsi@vger.kernel.org>
> Sent: Monday, March 13, 2017 9:06:38 PM
> Subject: Re: 4.10+ qla2xxx  driver wont load for qla2xxx (ISP2532-based 8Gb) with BAR 3 error, work fine on 4.9
> 
> 
> 
> ----- Original Message -----
> > From: "Laurence Oberman" <loberman@redhat.com>
> > To: "Himanshu Madhani" <Himanshu.Madhani@cavium.com>
> > Cc: "Chad Dupuis" <Chad.Dupuis@cavium.com>, "Linux SCSI List"
> > <linux-scsi@vger.kernel.org>
> > Sent: Monday, March 13, 2017 12:54:12 PM
> > Subject: Re: 4.10+ qla2xxx  driver wont load for qla2xxx (ISP2532-based
> > 8Gb) with BAR 3 error, work fine on 4.9
> > 
> > 
> > 
> > ----- Original Message -----
> > > From: "Himanshu Madhani" <Himanshu.Madhani@cavium.com>
> > > To: "Laurence Oberman" <loberman@redhat.com>, "Chad Dupuis"
> > > <Chad.Dupuis@cavium.com>
> > > Cc: "Linux SCSI List" <linux-scsi@vger.kernel.org>
> > > Sent: Monday, March 13, 2017 12:39:03 PM
> > > Subject: RE: 4.10+ qla2xxx  driver wont load for qla2xxx (ISP2532-based
> > > 8Gb) with BAR 3 error, work fine on 4.9
> > > 
> > > Hi Laurence,
> > > 
> > > > -----Original Message-----
> > > > From: Laurence Oberman [mailto:loberman@redhat.com]
> > > > Sent: Sunday, March 12, 2017 11:31 AM
> > > > To: Dupuis, Chad <Chad.Dupuis@cavium.com>; Madhani, Himanshu
> > > > <Himanshu.Madhani@cavium.com>
> > > > Cc: Linux SCSI List <linux-scsi@vger.kernel.org>
> > > > Subject: Re: 4.10+ qla2xxx driver wont load for qla2xxx (ISP2532-based
> > > > 8Gb)
> > > > with BAR 3 error, work fine on 4.9
> > > > 
> > > > 
> > > > 
> > > > ----- Original Message -----
> > > > > From: "Laurence Oberman" <loberman@redhat.com>
> > > > > To: "Chad Dupuis" <chad.dupuis@cavium.com>, "Himanshu Madhani"
> > > > > <Himanshu.Madhani@cavium.com>
> > > > > Cc: "Linux SCSI List" <linux-scsi@vger.kernel.org>
> > > > > Sent: Sunday, March 12, 2017 7:39:23 AM
> > > > > Subject: 4.10+ qla2xxx  driver wont load for qla2xxx (ISP2532-based
> > > > > 8Gb) with BAR 3 error, work fine on 4.9
> > > > >
> > > > > Chad, Himanshu
> > > > >
> > > > > Before I bisect or go chase changes, wanted to reach out because the
> > > > > driver seems to be the same version.
> > > > > Perhaps this is a PCIE change in the kernel for 4.10 affecting the
> > > > > load.
> > > > > Its the same targetLIO server I have been using for a long time with
> > > > > 4.9
> > > > >
> > > > > 27:00.0 Fibre Channel: QLogic Corp. ISP2532-based 8Gb Fibre Channel
> > > > > to
> > > > > PCI Express HBA (rev 02)
> > > > >
> > > > > With 4.9 I have no issues loading the driver for my targetLIO server.
> > > > > (DL380G8)
> > > > >
> > > > > # modinfo qla2xxx | more
> > > > > filename:
> > > > > /lib/modules/4.9.0.lobetcm+/kernel/drivers/scsi/qla2xxx/qla2xxx.ko
> > > > > firmware:       ql2500_fw.bin
> > > > > version:        8.07.00.38-k
> > > > > license:        GPL
> > > > > description:    QLogic Fibre Channel HBA Driver
> > > > > author:         QLogic Corporation
> > > > > srcversion:     94A8431A85BFF854B97B02D
> > > > >
> > > > > [    8.906351] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel
> > > > > HBA
> > > > > Driver: 8.07.00.38-k.
> > > > > [   10.014052] qla2xxx [0000:27:00.0]-001d: : Found an ISP2532 irq
> > > > > 106
> > > > > iobase
> > > > > 0xffffadce989a1000.
> > > > > [   10.455108] scsi host4: qla2xxx
> > > > > [   10.460206] qla2xxx [0000:27:00.0]-00fb:4: QLogic QLE2562 -
> > > > > PCI-Express
> > > > > Dual Channel 8Gb Fibre Channel HBA.
> > > > > [   10.460215] qla2xxx [0000:27:00.0]-00fc:4: ISP2532: PCIe (5.0GT/s
> > > > > x8)
> > > > > @
> > > > > 0000:27:00.0 hdma+ host#=4 fw=8.03.00 (90d5).
> > > > > [   10.460545] qla2xxx [0000:27:00.1]-001d: : Found an ISP2532 irq
> > > > > 110
> > > > > iobase
> > > > > 0xffffadce989a9000.
> > > > > [   10.662120] scsi host5: qla2xxx
> > > > > [   11.007841] qla2xxx [0000:27:00.1]-00fb:5: QLogic QLE2562 -
> > > > > PCI-Express
> > > > > Dual Channel 8Gb Fibre Channel HBA.
> > > > > [   11.007849] qla2xxx [0000:27:00.1]-00fc:5: ISP2532: PCIe (5.0GT/s
> > > > > x8)
> > > > > @
> > > > > 0000:27:00.1 hdma+ host#=5 fw=8.03.00 (90d5).
> > > > >
> > > > > Rebooting on the same server with 4.10 fails to load
> > > > >
> > > > > Linux  4.10.0+
> > > > > # modinfo qla2xxx | more
> > > > > filename:
> > > > > /lib/modules/4.10.0+/kernel/drivers/scsi/qla2xxx/qla2xxx.ko
> > > > > firmware:       ql2500_fw.bin
> > > > > version:        8.07.00.38-k
> > > > > license:        GPL
> > > > > description:    QLogic Fibre Channel HBA Driver
> > > > > author:         QLogic Corporation
> > > > > srcversion:     939E0595E8A3C2E1BE94392
> > > > >
> > > > > [    8.754040] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel
> > > > > HBA
> > > > > Driver: 8.07.00.38-k.
> > > > > [    9.979523] qla2xxx [0000:27:00.0]-001b: : BAR 3 not enabled.
> > > > > [   10.201268] qla2xxx [0000:27:00.0]-001d: : Found an ISP2532 irq
> > > > > 110
> > > > > iobase
> > > > > 0xffffacbf189b1000.
> > > > > [   10.407865] scsi host5: qla2xxx
> > > > > [   10.444281] qla2xxx: probe of 0000:27:00.0 failed with error -22
> > > > > [   10.444519] qla2xxx [0000:27:00.1]-001b: : BAR 3 not enabled.
> > > > > [   10.444522] qla2xxx [0000:27:00.1]-001d: : Found an ISP2532 irq
> > > > > 110
> > > > > iobase
> > > > > 0xffffacbf189b9000.
> > > > > [   10.645932] scsi host5: qla2xxx
> > > > > [   10.682233] qla2xxx: probe of 0000:27:00.1 failed with error -22
> > > > >
> > > > > Thanks
> > > > > Laurence
> > > > >
> > > > 
> > > > I started bisecting this, cannot believe others have not bumped into
> > > > this
> > > > on
> > > > 4.10.
> > > > This is a generic QLE2562 and firmware is loaded by the driver so
> > > > wondering
> > > > why I am seeing this and other are not.
> > > > There is nothing special with the PCIE bus on this DL380G8.
> > > > 
> > > > Anyway during the bisect I got to a point where in the 4.10 commits I
> > > > still
> > > > saw
> > > > the "BAR 3" message but the probe worked.
> > > > 
> > > > [    7.208237] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA
> > > > Driver:
> > > > 8.07.00.38-k.
> > > > [    7.208492] qla2xxx [0000:27:00.0]-001b: : BAR 3 not enabled.
> > > > 
> > > >        see this above but probe did not fail
> > > > 
> > > > [    7.208494] qla2xxx [0000:27:00.0]-001d: : Found an ISP2532 irq 97
> > > > iobase
> > > > 0xffffc02f98989000.
> > > > [    7.414738] scsi host4: qla2xxx
> > > > 
> > > > [    7.419267] qla2xxx [0000:27:00.0]-00fb:4: QLogic QLE2562 -
> > > > PCI-Express
> > > > Dual
> > > > Channel 8Gb Fibre Channel HBA.
> > > > [    7.419278] qla2xxx [0000:27:00.0]-00fc:4: ISP2532: PCIe (5.0GT/s
> > > > x8)
> > > > @
> > > > 0000:27:00.0 hdma+ host#=4 fw=8.03.00 (90d5).
> > > > [    7.419698] qla2xxx [0000:27:00.1]-001b: : BAR 3 not enabled.
> > > > [    7.419701] qla2xxx [0000:27:00.1]-001d: : Found an ISP2532 irq 100
> > > > iobase
> > > > 0xffffc02f989b1000.
> > > > [    7.625691] scsi host6: qla2xxx
> > > > [    7.629218] qla2xxx [0000:27:00.1]-00fb:6: QLogic QLE2562 -
> > > > PCI-Express
> > > > Dual
> > > > Channel 8Gb Fibre Channel HBA.
> > > > [    7.629222] qla2xxx [0000:27:00.1]-00fc:6: ISP2532: PCIe (5.0GT/s
> > > > x8)
> > > > @
> > > > 0000:27:00.1 hdma+ host#=6
> > > > 
> > > > I marked that still as bad and am continuing, I have 9 builds to go.
> > > > 
> > > > Thanks
> > > > Laurence
> > > 
> > >  We had send patches to address issues discovered when the PCI Affinity
> > >  were
> > >  merged into 4.10 kernel.
> > > 
> > > Can you please check if your tree has following patches (Currently they
> > > are
> > > included in 4.10.2 stable)
> > > 
> > > https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git/commit/?id=154f7a1523b717cad67e0b3d2ed4c660fd1b2e7c
> > > 
> > > https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git/commit/?id=699abe249b0e2ca590284424d95490e92ccd6aeb
> > > 
> > > https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git/commit/?id=cf9d9110806493e2ea2db7d00a1a991401dfb9d5
> > > 
> > > Also can you apply following patch which addresses issue in PCI layer
> > > (This
> > > should be included in 4.10 stable branch soon )
> > > 
> > > https://www.spinics.net/lists/linux-pci/msg58742.html
> > > 
> > > Thanks,
> > > Himanshu
> > > 
> > 
> > Hello Himanshu
> > 
> > Many thanks for coming back to me.
> > OK, I will test all of this and let you know.
> > I dont think I have these and this would explain all this.
> > 
> > Regards
> > Laurence
> > 
> 
> Hello Himanshu
> This is still failing for me on the HP DL380G8
> 
> My Stable tree
> 
> root@dhcp40-131 ~]# uname -a
> Linux xxxxxx.desklab.eng.bos.redhat.com 4.11.0-rc2+
> 
> $ git show 154f7a1523b717cad67e0b3d2ed4c660fd1b2e7c
> commit 154f7a1523b717cad67e0b3d2ed4c660fd1b2e7c
> Author: Michael Hernandez <michael.hernandez@cavium.com>
> Date:   Wed Feb 15 15:37:21 2017 -0800
> 
>     scsi: qla2xxx: Fix Regression introduced by
>     pci_alloc_irq_vectors_affinity call.
>     
>     commit 67f2db8792f96d8f7521461635d25f9c80245d80 upstream.
>     
>     For target mode, we need to increase minimum vectors value by one to
>     account for ATIO queue.
>     
>     Following stack trace will be seen
> 
> $ git show 699abe249b0e2ca590284424d95490e92ccd6aeb
> commit 699abe249b0e2ca590284424d95490e92ccd6aeb
> Author: Michael Hernandez <michael.hernandez@cavium.com>
> Date:   Wed Feb 15 15:37:20 2017 -0800
> 
>     scsi: qla2xxx: Fix response queue count for Target mode.
>     
>     commit d0d2c68b759bbf678e078fd0c71b5fde65a9392c upstream.
>     
>     Target mode initialization was not calculating response queue values
>     correctly resulting into one less MSI-X vector.
> 
> $ git show cf9d9110806493e2ea2db7d00a1a991401dfb9d5
> commit cf9d9110806493e2ea2db7d00a1a991401dfb9d5
> Author: Michael Hernandez <michael.hernandez@cavium.com>
> Date:   Wed Feb 15 15:37:19 2017 -0800
> 
>     scsi: qla2xxx: Cleaned up queue configuration code.
>     
>     commit f54f2cb540b53d55a81d620e816810d59be5cb1b upstream.
>     
>     This patch cleaned up queue configuration code, such that once
>     initialized, we should not touch msix_count value.  This will prevent
>     incorrect numbers of MSI-X vectors requested while performing target
>     mode configuration.
>     
> 
> Tested, and fails
> 
> root@dhcp40-131 ~]# dmesg | grep qla
> [    8.007786] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA
> Driver: 8.07.00.38-k.
> [    9.583949] qla2xxx [0000:27:00.0]-001b: : BAR 3 not enabled.
> [    9.583951] qla2xxx [0000:27:00.0]-001d: : Found an ISP2532 irq 106 iobase
> 0xffffb3e4589a1000.
> [    9.788259] scsi host4: qla2xxx
> [    9.824578] qla2xxx: probe of 0000:27:00.0 failed with error -22
> [    9.824824] qla2xxx [0000:27:00.1]-001b: : BAR 3 not enabled.
> [    9.824828] qla2xxx [0000:27:00.1]-001d: : Found an ISP2532 irq 106 iobase
> 0xffffb3e4589a9000.
> [   10.030273] scsi host4: qla2xxx
> [   10.066602] qla2xxx: probe of 0000:27:00.1 failed with error -22
> 
> 
> Now
> Patched
> https://www.spinics.net/lists/linux-pci/msg58742.html
> 
> [loberman@dhcp40-131 linux-stable]$ patch -p1 < ../patch_pci
> patching file drivers/pci/msi.c
> Hunk #1 succeeded at 1072 (offset -19 lines).
> Hunk #2 succeeded at 1120 (offset -27 lines).
> Hunk #3 succeeded at 1200 (offset -27 lines).
> 
> Rebuild kernel
> Reboot and test
> 
> Still fails
> 
> [    8.464491] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA
> Driver: 8.07.00.38-k.
> [    8.464672] qla2xxx [0000:27:00.0]-001b: : BAR 3 not enabled.
> [    8.464675] qla2xxx [0000:27:00.0]-001d: : Found an ISP2532 irq 101 iobase
> 0xffffa3ff58991000.
> [    8.670118] scsi host4: qla2xxx
> [    8.706325] qla2xxx: probe of 0000:27:00.0 failed with error -22
> [    8.706451] qla2xxx [0000:27:00.1]-001b: : BAR 3 not enabled.
> [    8.706453] qla2xxx [0000:27:00.1]-001d: : Found an ISP2532 irq 101 iobase
> 0xffffa3ff589a1000.
> [    8.912089] scsi host4: qla2xxx
> [    8.948324] qla2xxx: probe of 0000:27:00.1 failed with error -22
> 
> Went to test on another system , HP Microserver G8
> Same HBA
> Fibre Channel: QLogic Corp. ISP2532-based 8Gb Fibre Channel to PCI Express
> HBA (rev 02)
> 
> Works here but complains about the vector count support
> 
> [    8.056438] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA
> Driver: 8.07.00.38-k.
> [    8.097427] qla2xxx [0000:07:00.0]-001a: : MSI-X vector count: 32.
> [    8.127130] qla2xxx [0000:07:00.0]-001d: : Found an ISP2532 irq 16 iobase
> 0xffffbd9100c99000.
> [    8.221834] qla2xxx [0000:07:00.0]-00c6:6: MSI-X: Failed to enable support
> with 32 vectors, using 4 vectors.
> [    8.759660] scsi host6: qla2xxx
> [    8.760085] qla2xxx [0000:07:00.0]-00fb:6: QLogic HPAJ764A - HP 8Gb Dual
> Channel PCI-e 2.0 FC HBA.
> [    8.760092] qla2xxx [0000:07:00.0]-00fc:6: ISP2532: PCIe (5.0GT/s x8) @
> 0000:07:00.0 hdma+ host#=6 fw=8.03.00 (90d5).
> [    8.760197] qla2xxx [0000:07:00.1]-001a: : MSI-X vector count: 32.
> [    8.760199] qla2xxx [0000:07:00.1]-001d: : Found an ISP2532 irq 17 iobase
> 0xffffbd9100cb9000.
> [    8.760428] qla2xxx [0000:07:00.1]-00c6:7: MSI-X: Failed to enable support
> with 32 vectors, using 4 vectors.
> [    8.999658] scsi host7: qla2xxx
> [    9.000124] qla2xxx [0000:07:00.1]-00fb:7: QLogic HPAJ764A - HP 8Gb Dual
> Channel PCI-e 2.0 FC HBA.
> [    9.000130] qla2xxx [0000:07:00.1]-00fc:7: ISP2532: PCIe (5.0GT/s x8) @
> 0000:07:00.1 hdma+ host#=7 fw=8.03.00 (90d5).
> 
> So something about the DL380 here needs to be figured out as well as the
> MSI-X messages above.
> 
> Earlier kernels up to 4.9.13 are all fine on both servers
> 
> Thanks
> Laurence
> 

I meant to add
 
With the G8 Microserver links seem to come up with only the 4 MSI-X vectors but I get this
so it not fully healthy

[  373.823667] Rounding down aligned max_sectors from 65535 to 65528
[  399.994495] qla2xxx [0000:07:00.0]-00af:6: Performing ISP error recovery - ha=ffffa0e934210000.
[  400.728968] qla2xxx [0000:07:00.0]-500a:6: LOOP UP detected (8 Gbps).
[  401.473405] qla2xxx [0000:07:00.0]-5030:6: Error entry - invalid handle/queue (1c01).   ***** Note
[  426.966519] qla2xxx [0000:07:00.1]-00af:7: Performing ISP error recovery - ha=ffffa0e934e30000.
[  427.697601] qla2xxx [0000:07:00.1]-500a:7: LOOP UP detected (8 Gbps).
[  428.473948] qla2xxx [0000:07:00.1]-5030:7: Error entry - invalid handle/queue (1c01).   ***** Note
