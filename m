From: Mark Haverkamp <markh@osdl.org>
Subject: Re: aix7xxx_old woes in 2.5
Date: 16 Dec 2002 10:01:41 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1040061701.13086.1.camel@markh1.pdx.osdl.net>
References: <3DFC06C9.19AFADE2@digeo.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3DFC06C9.19AFADE2@digeo.com>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@digeo.com>
Cc: linux-scsi@vger.kernel.org

On Sat, 2002-12-14 at 20:36, Andrew Morton wrote:
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
> 
> 
> Note that I have set the machine's BIOS up to not run external BIOSes, so the
> Adaptec firmware is not being used.  Reboot times are unacceptable otherwise.
> 
> This doesn't seem to offend the 2.4 aic7xxx driver, nor the 2.5 aic7xxx 75%
> of the time...
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

I had some problems like this with a megaraid card recently.  Once I
turned off ACPI in the config, things started working OK.


-- 
Mark Haverkamp <markh@osdl.org>

