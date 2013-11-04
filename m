From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: scsi-mq + open-iscsi support patches..?
Date: Mon, 04 Nov 2013 10:56:51 -0800
Message-ID: <1383591411.4216.25.camel@haakon3.risingtidesystems.com>
References: <1382997816.19256.767.camel@haakon3.risingtidesystems.com>
	 <5273BEBF.2090008@cs.wisc.edu>
	 <1383338230.4216.9.camel@haakon3.risingtidesystems.com>
	 <37724B2049F71D4C9B086F99DDB2DE1126E31C7C@CMEXMB1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <37724B2049F71D4C9B086F99DDB2DE1126E31C7C@CMEXMB1.ad.emulex.com>
Sender: target-devel-owner@vger.kernel.org
To: Jayamohan Kallickal <Jayamohan.Kallickal@Emulex.Com>
Cc: "open-iscsi@googlegroups.com" <open-iscsi@googlegroups.com>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>, Or Gerlitz <ogerlitz@mellanox.com>
List-Id: linux-scsi@vger.kernel.org

On Sat, 2013-11-02 at 16:10 +0000, Jayamohan Kallickal wrote:

<SNIP>

> >> On a related note, some iscsi vendor has been hitting a crash with 
> >> your tree.
> 
> >I got an email from Jayamohan recently, but the OOPs did not appear to be scsi-mq related..
> 
> I do see the crash on my Ubuntu VM running on VirtualBox  but don't see the crash on a Standalone system. 
> Attaching the screenshot
> 

Hi Jayamohan,

Care to enable the virtual serial port for this VM in order to grab the
full dmesg output..?

Also, an idea of what SATA emulation is being used here would be helpful
as well.  (eg: lspci -vvv for the ATA device on the running system)

--nab
