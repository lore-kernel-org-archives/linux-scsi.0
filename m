From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: 2.4.39 "Sleeping function called from illegal context at slab.c:1374"
Date: Thu, 3 Oct 2002 10:17:38 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021003171738.GA1106@beaverton.ibm.com>
References: <3D99885B.533C320D@aitel.hist.no> <3D99EF62.3A3E6932@digeo.com> <20021001215907.GA8273@midgaard.us> <3D9A207A.14BFF440@digeo.com> <20021002162443.GA1317@beaverton.ibm.com> <20021002184437.GA17474@midgaard.us> <20021002212122.GF1317@beaverton.ibm.com> <20021002235349.GA20442@midgaard.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021002235349.GA20442@midgaard.us>
List-Id: linux-scsi@vger.kernel.org
To: akpm@digeo.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, dougg@gear.torque.net

Andreas,
	I noticed a problem with the scsi_error.c update the I made to
	2.5.40. There is a typo in the the tur check on error handling.
	I tested the patch yesterday and it is recovering better on
	faults. 

	I do not know if it will fix your problem, but it might be worth
	a try.
	
	I will send it to you in bit I am in the process of
	rolling it and other patches that depend on it up.


Andreas Boman [aboman@nerdfest.org] wrote:
> * Mike Anderson (andmike@us.ibm.com) wrote:
> > Andreas,
> > 	Here is the updated patch.
> > 
> 
> Yep, no more warnings on modprobe sg. Unfortenuately the box still hangs after 
> modprobe ide-scsi:
> 
>  scsi1 : SCSI host adapter emulation for IDE ATAPI devices
>  scsi_eh_offline_sdevs: Device set offline - notready or command retry failedafter error recovery: host1 channel 0 id 0 lun 0
>    Vendor:           Model:                   Rev:     
>    Type:   Direct-Access                      ANSI SCSI revision: 00
>  hda: lost interrupt
>  ide-scsi: CoD != 0 in idescsi_pc_intr
>  hda: DMA disabled
>  hda: ATAPI reset complete
> 
> 
> andreas
-andmike
--
Michael Anderson
andmike@us.ibm.com

