From: "Milton D. Miller II" <miltonm@realtime.net>
Subject: Re: Aic7xxx v6.2.22 and Aic79xx v1.3.0Alpha2 Released
Date: Fri, 13 Dec 2002 23:57:51 -0600 (CST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200212140557.gBE5vp365560@sullivan.realtime.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: gibbs@scsiguy.com


Justin wrote:
>I dont' want to reserve regions that I'm not going to use because that
>resource space might be vital for some future hot-plug device.  The fact
>that the BIOSes allocate all regions is a holdover from when OSes were
>not PCI PNP capable.

2.4.20-pre3 (mid August) added pci_enable_device_bars so you can select
which bars you are going to use, and therefore not enable io (memory)
space ... it was needed for some of the ide adapters.

milton
