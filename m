From: Mrvka Andreas <mrv@tuev-a.at>
Subject: Re: installing new MegaRaid driver on Suse Enterprise Server 8
Date: Wed, 23 Feb 2005 17:35:19 +0100
Message-ID: <200502231735.19675.mrv@tuev-a.at>
References: <0E3FA95632D6D047BA649F95DAB60E57036626DD@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Received: from [194.242.41.130] ([194.242.41.130]:8383 "EHLO mail.tuev-a.at")
	by vger.kernel.org with ESMTP id S261496AbVBWQf0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Feb 2005 11:35:26 -0500
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E57036626DD@exa-atlanta>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ju, Seokmann" <sju@lsil.com>, linux-scsi@vger.kernel.org

Hello!

Thanks for your response!

well, i installed SLES 8 and the system found its PERC 2/dc
as an i2o block device.
it loads all i2o_core, i2o_block, i2o_config, and i2o_pci

and at i2o_pci it says to wait for more devices in the background....
but it does get an timeout back.
so i believe the i2o module is not that correct one.

i used to try the following modules: (rpm packages)
megaraid-megamgr-1.07-5
megaraid2-2.10.1-3dkms

can you guide me through updating to actual megaraid version?
well, i believe that this is what i have to try next.
cause, there is no kernel update for SLES 8 available :-(

thanks,
andrew


Am Mittwoch, 23. Februar 2005 16:57 schrieb Ju, Seokmann:
> On Wednesday, February 23, 2005 9:47 AM, Mrvka wrote:
> 
> Please let me know what version of driver you are using.
> Also, Is O/S installed on the device connected to megaraid controller?
> 
> Thanks,
> 
> > -----Original Message-----
> > From: Mrvka Andreas [mailto:mrv@tuev-a.at]
> > Sent: Wednesday, February 23, 2005 9:47 AM
> > To: linux-scsi@vger.kernel.org
> > Subject: installing new MegaRaid driver on Suse Enterprise Server 8
> > 
> > hi list,
> > 
> > does anybody can help to guide me through an update
> > of an megaraid driver?
> > 
> > i have a Dell Perc 2/dc controller in my Dell 2450 Server and
> > SuSE Server 8.
> > 
> > if i use the standard megaraid driver, then the server crashes
> > and stands... (no error log entry)
> > 
> > i found many sites for updates but no instruction for that.
> > 
> > can anybody please support me?
> > 
> > thanks in advance!
> > 
> > cheers
> > Andrew
> > 
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

