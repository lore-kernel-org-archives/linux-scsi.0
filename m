From: "Alexander Stohr" <Alexander.Stohr@gmx.de>
Subject: return value warnings about scsi_add_host, anything in progress?
Date: Mon, 7 Feb 2005 10:40:18 +0100 (MET)
Message-ID: <10482.1107769218@www35.gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Received: from mail.gmx.de ([213.165.64.20]:19334 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S261376AbVBGJkT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Feb 2005 04:40:19 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

is anything going to happen with the below listed locations?
(Some are part of the USB system, one is in block device, rest is SCSI.)
Note that a few locations do still lack the "XXX" comment.

I am asking because i am seeing ther respective warning
anytime when i am checking the quality of a new linux kernel.
And now i am wondering if there is already some work in progress
or already pending in the queue for submitting to bitkeeper.

-Alex.

PS: i am not subscribed to that list, so please CC me on replys.
Hunting answers via the list archives is not always successful.


./drivers/usb/image/hpusbscsi.c:112:    scsi_add_host(new->host,
&intf->dev); /* XXX handle failure */                                       
                  
./drivers/usb/image/microtek.c:812:     scsi_add_host(new_desc->host, NULL);
/* XXX handle failure */                                                    
      
./drivers/scsi/arm/ecoscsi.c:208:       scsi_add_host(host, NULL); /* XXX
handle failure */                                                           
         
./drivers/scsi/megaraid.c:4890: error = scsi_add_host(host, &pdev->dev);    
   
./drivers/scsi/aic7xxx/aic7xxx_osm.c:1732:      scsi_add_host(host,
(ahc->dev_softc ? &ahc->dev_softc->dev : NULL)); /* XXX handle failure */   
               
./drivers/scsi/aic7xxx/aic79xx_osm.c:2068:      scsi_add_host(host,
&ahd->dev_softc->dev); /* XXX handle failure */                             
               
./drivers/scsi/pcmcia/fdomain_stub.c:226:    scsi_add_host(host, NULL); /*
XXX handle failure */                                                       
        
./drivers/scsi/pcmcia/nsp_cs.c:1908:    scsi_add_host (host, NULL);         
   
./drivers/scsi/mac53c94.c:506:  scsi_add_host(host, &mdev->ofdev.dev);      
   
./drivers/scsi/nsp32.c:2891:    scsi_add_host (host, &PCIDEV->dev);         
   
./drivers/scsi/mesh.c:1963:     scsi_add_host(mesh_host, &mdev->ofdev.dev); 
   
./drivers/scsi/aha1740.c:645:   scsi_add_host (shpnt, dev); /* XXX handle
failure */                                                                  
         
./drivers/scsi/BusLogic.c:2299:                         scsi_add_host(Host,
NULL);                                                                      
       
./drivers/block/cciss_scsi.c:709:       scsi_add_host(sh,
&hba[ctlr]->pdev->dev); /* XXX handle failure *

-- 
DSL Komplett von GMX +++ Supergünstig und stressfrei einsteigen!
AKTION "Kein Einrichtungspreis" nutzen: http://www.gmx.net/de/go/dsl
