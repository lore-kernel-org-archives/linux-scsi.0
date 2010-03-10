From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: RE: Controlling mpt2sas busy retries
Date: Wed, 10 Mar 2010 14:29:33 +0530
Message-ID: <1C9608B8A4CD534FB19C7C7543CBB249020E1A7BD6@inbmail02.lsi.com>
References: <02B16CD25461354295D12236BDA8C0E195BF0794FB@EXMAIL.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog106.obsmtp.com ([74.125.149.77]:50618 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752949Ab0CJI7o convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Mar 2010 03:59:44 -0500
In-Reply-To: <02B16CD25461354295D12236BDA8C0E195BF0794FB@EXMAIL.ad.emulex.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Bill.Hooper@Emulex.Com" <Bill.Hooper@Emulex.Com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Bill,

command_retry_count is not part of upstream driver. command_retry_count experimental support of mpt2sas driver.
What exactly is your need ?
Normally retries should happened out of LLD(mpt2sas). It must be handled at scsi midlayer.
So you have to trust midlayer instead of LLD.

--Kashyap

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Bill.Hooper@Emulex.Com
> Sent: Wednesday, March 03, 2010 5:58 AM
> To: linux-scsi@vger.kernel.org; Bill.Hooper@Emulex.Com
> Subject: Controlling mpt2sas busy retries
> 
> I would like to control the number of times the mpt2sas driver retries
> a command on BUSY (I want to reduce the retry to zero or one). I found
> a document that explains I could use command_retry_count parameter when
> loading the driver, but the parameter does not exist for my driver. Any
> help would be appreciated.
> 
> Bill Hooper
> Principal Software Engineer
> Emulex
> 
> root@spice (<-;)~ # uname -a
> Linux spice 2.6.31-19-generic #56-Ubuntu SMP Thu Jan 28 01:26:53 UTC
> 2010 i686 GNU/Linux
> 
> root@spice (<-;)~ # modinfo mpt2sas
> filename:       /lib/modules/2.6.31-19-
> generic/kernel/drivers/scsi/mpt2sas/mpt2sas.ko
> version:        01.100.04.00
> license:        GPL
> description:    LSI MPT Fusion SAS 2.0 Device Driver
> author:         LSI Corporation <DL-MPTFusionLinux@lsi.com>
> srcversion:     65EA54D38B5A4AB0E385215
> alias:          pci:v00001000d00000065sv*sd*bc*sc*i*
> alias:          pci:v00001000d00000064sv*sd*bc*sc*i*
> alias:          pci:v00001000d00000077sv*sd*bc*sc*i*
> alias:          pci:v00001000d00000076sv*sd*bc*sc*i*
> alias:          pci:v00001000d00000074sv*sd*bc*sc*i*
> alias:          pci:v00001000d00000072sv*sd*bc*sc*i*
> alias:          pci:v00001000d00000070sv*sd*bc*sc*i*
> depends:        scsi_transport_sas
> vermagic:       2.6.31-19-generic SMP mod_unload modversions 586
> parm:           logging_level: bits for enabling additional logging
> info (default=0)
> parm:           max_lun: max lun, default=16895  (int)
> parm:           max_queue_depth: max controller queue depth  (int)
> parm:           max_sgl_entries: max sg entries  (int)
> parm:           msix_disable: disable msix routed interrupts
> (default=0) (int)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
