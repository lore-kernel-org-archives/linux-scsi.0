From: James Shubin <purpleidea@gmail.com>
Subject: Re: Status of the LSI 2108
Date: Thu, 20 Jan 2011 18:57:06 -0500
Message-ID: <1295567826.20086.89.camel@localhost>
References: <1295411153.20086.81.camel@localhost>
	 <20110120153419.806d38e1.rdunlap@xenotime.net>
Reply-To: purpleidea@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110120153419.806d38e1.rdunlap@xenotime.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: scsi <linux-scsi@vger.kernel.org>, linux-kernel@vger.kernel.org, DL-MPTFusionLinux@lsi.com
List-Id: linux-scsi@vger.kernel.org

Thanks Randy for sending me in the right direction.
Hello linux-scsi and LSI. Any thoughts to the below question would be
much appreciated!

James


On Thu, 2011-01-20 at 15:34 -0800, Randy Dunlap wrote:
> On Tue, 18 Jan 2011 23:25:53 -0500 James Shubin wrote:
> 
> > Hi,
> > 
> > I've been trying to find out if the LSI 2108 is fully supported in the
> > vanilla kernel, and any thoughts as to the quality/robustness.
> > 
> > This seems to be the correct source:
> > ftp://ftp.supermicro.nl/driver/SAS/LSI/2108/Driver/Linux/v04.31/
> > however I'm not sure at all if it's maintained, or what. I would
> > outright test this myself, however I haven't bought the servers yet
> > 
> > Thanks for your help,
> > Please cc-me on replies.
> 
> Hi,
> 
> Probably better to ask on the linux-scsi mailing list [added].
> Also added the lsi.com email address.
> 
> 
> drivers/scsi/mpt2sas/mpt2sas_scsih.c contains this:
> 
> 	/* Liberator ~ 2108 */
> 	{ MPI2_MFGPAGE_VENDORID_LSI, MPI2_MFGPAGE_DEVID_SAS2108_1,
> 		PCI_ANY_ID, PCI_ANY_ID },
> 	{ MPI2_MFGPAGE_VENDORID_LSI, MPI2_MFGPAGE_DEVID_SAS2108_2,
> 		PCI_ANY_ID, PCI_ANY_ID },
> 	{ MPI2_MFGPAGE_VENDORID_LSI, MPI2_MFGPAGE_DEVID_SAS2108_3,
> 		PCI_ANY_ID, PCI_ANY_ID },
> 
> so it looks like there is at least some basic support for the 2108.
> 
> 
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
