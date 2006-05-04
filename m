From: "Ju, Seokmann" <Seokmann.Ju@lsil.com>
Subject: RE: [PATCH] MegaRAID driver management char device moved to misc
Date: Thu, 4 May 2006 08:05:14 -0600
Message-ID: <890BF3111FB9484E9526987D912B261901BD2D@NAMAIL3.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:40175 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1751157AbWEDOF0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 May 2006 10:05:26 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Thomas Horsten <thomas@horsten.com>
Cc: linux-kernel@vger.kernel.org, "Kolli, Neela" <Neela.Kolli@engenio.co>, linux-scsi@vger.kernel.org

Hi, 
> > > So it now uses a misc device which I named "megadev0" (the
> > > name that megarc
> > > expects), and has a dynamic minor (previoulsy a dynamic major
> > > was used).
> > The driver can not change device node name for backward 
> compatibility.
> > I'm checking with application team inside for further 
> clarification and update here.
> 
> That is an invalid reason: There was no hardcoded device node 
> previously
> (it was using a dynamically assigned major).
You're right.
I misunderstood the whole idea of creating device node.
Besides this, I don't have any objection.
I would accept the patch based on descriptoin in flowing link.
http://www.us.kernel.org/pub/linux/utils/kernel/hotplug/udev_vs_devfs

Any other comment would be appreciated.

Thank you,

> -----Original Message-----
> From: Thomas Horsten [mailto:thomas@horsten.com] 
> Sent: Thursday, May 04, 2006 9:38 AM
> To: Ju, Seokmann
> Cc: linux-kernel@vger.kernel.org; Kolli, Neela; 
> linux-scsi@vger.kernel.org
> Subject: RE: [PATCH] MegaRAID driver management char device 
> moved to misc
> 
> On Thu, 4 May 2006, Ju, Seokmann wrote:
> 
> > Hi,
> >
> > For following reason, I cannot accept/approve this patch.
> > I'll update further as I get clear.
> >
> > Thank you,
> >
> > > So it now uses a misc device which I named "megadev0" (the
> > > name that megarc
> > > expects), and has a dynamic minor (previoulsy a dynamic major
> > > was used).
> > The driver can not change device node name for backward 
> compatibility.
> > I'm checking with application team inside for further 
> clarification and update here.
> 
> That is an invalid reason: There was no hardcoded device node 
> previously
> (it was using a dynamically assigned major).
> 
> The only tool I know which uses this device is "megarc" from 
> LSI Logic.
> This tool uses the char device /dev/megaraid0, which will be created
> correctly when using my patch and udev (the recommended setup 
> for Linux
> 2.6 systems). I have tested this and it works.
> 
> User-level applications should not rely on hardcoded device 
> numbers in any
> case, but should use the correct device from /dev or search 
> for the device
> they need in sysfs.
> 
> Thomas
> 
> 
