From: Doug Ledford <dledford@redhat.com>
Subject: Re: aix7xxx_old woes in 2.5
Date: Mon, 16 Dec 2002 02:40:08 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021216074008.GC13989@redhat.com>
References: <3DFC06C9.19AFADE2@digeo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3DFC06C9.19AFADE2@digeo.com>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@digeo.com>
Cc: linux-scsi@vger.kernel.org

On Sat, Dec 14, 2002 at 08:36:25PM -0800, Andrew Morton wrote:
> 
> ho hum.
> 
> It just doesn't start at all:
> 
> scsi HBA driver <NULL> didn't set max_sectors, please fix the template<6>(scsi0) <Adaptec AIC-7892 Ultra 160/m SCSI host adapter> found at PCI 3/4/0
> (scsi0) Wide Channel, SCSI ID=7, 32/255 SCBs
> (scsi0) Downloading sequencer code... 396 instructions downloaded
> (scsi1) <Adaptec AIC-7880 Ultra SCSI host adapter> found at PCI 0/10/0
> (scsi1) Wide Channel, SCSI ID=7, 16/255 SCBs
> (scsi1) Downloading sequencer code... 436 instructions downloaded
> scsi0 : Adaptec AHA274x/284x/294x (EISA/VLB/PCI-Fast SCSI) 5.2.6/5.2.0
>        <Adaptec AIC-7892 Ultra 160/m SCSI host adapter>
> scsi: Device offlined - not ready or command retry failed after error recovery: host 0 channel 0 id 0 lun 0
> scsi: Device offlined - not ready or command retry failed after error recovery: host 0 channel 0 id 1 lun 0
> scsi: Device offlined - not ready or command retry failed after error recovery: host 0 channel 0 id 2 lun 0
> scsi: Device offlined - not ready or command retry failed after error recovery: host 0 channel 0 id 3 lun 0
> scsi: Device offlined - not ready or command retry failed after error recovery: host 0 channel 0 id 4 lun 0
> scsi: Device offlined - not ready or command retry failed after error recovery: host 0 channel 0 id 5 lun 0
> scsi: Device offlined - not ready or command retry failed after error recovery: host 0 channel 0 id 6 lun 0
> scsi: Device offlined - not ready or command retry failed after error recovery: host 0 channel 0 id 8 lun 0
> 
> (The above took three minutes or more)

Interrupt routing problems is what that looks like to me, not driver 
problems.  Try booting with different interrupt settings or with a 
different kernel (smp vs. up, that sort of thing).

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
