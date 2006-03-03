From: "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: Re: [RFC] aic94xx: attaching to the sas transport class
Date: Thu, 2 Mar 2006 20:04:19 -0800
Message-ID: <20060302200419.b37c2fd9.rdunlap@xenotime.net>
References: <1141339085.3238.80.camel@mulgrave.il.steeleye.com>
	<20060302231323.GA12869@us.ibm.com>
	<A421A6E6-A405-4DEC-847D-C5F33AA0718F@mac.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:10638 "HELO xenotime.net")
	by vger.kernel.org with SMTP id S1752081AbWCCEC4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Mar 2006 23:02:56 -0500
Received: from midway.site ([71.111.157.99]) by xenotime.net for <linux-scsi@vger.kernel.org>; Thu, 2 Mar 2006 20:02:55 -0800
In-Reply-To: <A421A6E6-A405-4DEC-847D-C5F33AA0718F@mac.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Rustad <mrustad@mac.com>
Cc: andmike@us.ibm.com, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, Robert_Tarte@adaptec.com

On Thu, 2 Mar 2006 20:16:20 -0600 Mark Rustad wrote:

> On Mar 2, 2006, at 5:13 PM, Mike Anderson wrote:
> 
> > James Bottomley <James.Bottomley@SteelEye.com> wrote:
> >> This fairly minimal patch correctly attaches the aic94xx driver to  
> >> the
> >> SAS transport class (The driver is available from
> >>
> >> www.kernel.org/git/jgarzik/sas-2.6
> >>
> >> ).  Unfortunately, the driver itself still has the following critical
> >> issues
> >>
> >> 1. Discovery order is non-deterministic (it starts one thread per  
> >> port,
> >> so the threads race for discovery)
> >
> > The issue also results in the device discovery not completing by  
> > the time
> > the module load completes resulting in the initrd not finding the boot
> > disk
> > http://bugzilla.kernel.org/show_bug.cgi?id=6045
> >
> > I agree that we need a solution for this. Should the solution be in  
> > the
> > LLDDs.I thought previous comments was that we wanted this fixed  
> > outside
> > the kernel in user space. Though I have not seen any enabled  
> > support in
> > initrds or support in the initrd bins.
> >
> > This appears to not only be an issue with aic94xx as it appears  
> > this could
> > happen with some of the fc transport LLDDs.
> 
> It also is a problem for usb-storage devices. I have to use a kernel  
> parameter of "boot_delay=7" for my USB root device to be available.  
> Fine for my system, but ugly in general.

where is that kernel boot option, pray tell?
I don't seem to be able to find it.

---
~Randy
