From: Andreas Boman <aboman@nerdfest.org>
Subject: Re: 2.4.39 "Sleeping function called from illegal context at slab.c:1374"
Date: Wed, 2 Oct 2002 19:53:49 -0400
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20021002235349.GA20442@midgaard.us>
References: <3D99885B.533C320D@aitel.hist.no> <3D99EF62.3A3E6932@digeo.com> <20021001215907.GA8273@midgaard.us> <3D9A207A.14BFF440@digeo.com> <20021002162443.GA1317@beaverton.ibm.com> <20021002184437.GA17474@midgaard.us> <20021002212122.GF1317@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021002212122.GF1317@beaverton.ibm.com>
To: Mike Anderson <andmike@us.ibm.com>
Cc: akpm@digeo.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, dougg@gear.torque.net
List-Id: linux-scsi@vger.kernel.org

* Mike Anderson (andmike@us.ibm.com) wrote:
> Andreas,
> 	Here is the updated patch.
> 

Yep, no more warnings on modprobe sg. Unfortenuately the box still hangs after 
modprobe ide-scsi:

 scsi1 : SCSI host adapter emulation for IDE ATAPI devices
 scsi_eh_offline_sdevs: Device set offline - notready or command retry failedafter error recovery: host1 channel 0 id 0 lun 0
   Vendor:           Model:                   Rev:     
   Type:   Direct-Access                      ANSI SCSI revision: 00
 hda: lost interrupt
 ide-scsi: CoD != 0 in idescsi_pc_intr
 hda: DMA disabled
 hda: ATAPI reset complete


andreas
