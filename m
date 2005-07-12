From: Kallol Biswas <kallol@nucleodyne.com>
Subject: Re: LSI MegaRAID SATA 300-X8 problems
Date: 12 Jul 2005 07:40:47 -0700
Message-ID: <1121179247.8199.3.camel@driver>
References: <42A5F235.6000300@buf.fr> <42A601E0.8090404@buf.fr>
	 <42A85F96.5080608@buf.fr>
Reply-To: kallol@nucleodyne.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sccrmhc13.comcast.net ([204.127.202.64]:6312 "EHLO
	sccrmhc13.comcast.net") by vger.kernel.org with ESMTP
	id S261489AbVGLOnZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Jul 2005 10:43:25 -0400
In-Reply-To: <42A85F96.5080608@buf.fr>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alexander Jolk <alexj@buf.fr>
Cc: linux-scsi@vger.kernel.org

Hello Alexander,
               Could you get the LSI MegaRAID SATA 300-8X controller
working for a long duration?

Have you run any performance benchmark on it yet? How much bandwidth do
you get with the controller?

Thanks,
Kallol
kallol@nucleodyne.com
http://www.nucleodyne.com

On Thu, 2005-06-09 at 08:26, Alexander Jolk wrote:
> Alexander Jolk wrote:
> >  Jolk wrote:
> > 
> >> I'm trying to get an LSI MegaRAID SATA 300-X8 controller to work on a 
> >> Debian/sarge system with kernel 2.6.11-9-em64t-p4-smp from unstable. 
> >> The megaraid_mbox module is loaded and seems to identify the 
> >> controller, but whenever I try to access the disk, I get SCSI errors, 
> >> the controller alarm goes off, and upon inspection in the BIOS, the 
> >> first SATA disc is marked `FAILED'.  Reconfiguring the RAID lets me 
> >> restart the whole process.
> > 
> > 
> > Following up to myself, I compiled my own kernel 2.6.11.11 and things 
> > appear to work so far.  Known problem that has been fixed, or worth 
> > investigating?
> 
> Any pointers, anybody?  While things are working a little better, I 
> still get a complete RAID crash every once in a while (a few hours of 
> use, typically).  Since I have got no reaction so far, is more 
> information needed, or should I take my questions somewhere else?  Where?
> 
> Alex
> 

