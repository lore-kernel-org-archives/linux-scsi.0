From: "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: Re: [GIT PATCH] SCSI updates for 2.6.17
Date: Wed, 21 Jun 2006 13:07:45 -0700
Message-ID: <20060621130745.aed5d1c9.rdunlap@xenotime.net>
References: <1150837947.2531.27.camel@mulgrave.il.steeleye.com>
	<4498A050.8080403@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:64187 "HELO xenotime.net")
	by vger.kernel.org with SMTP id S1751324AbWFUUE6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Jun 2006 16:04:58 -0400
Received: from midway.site ([71.245.102.105]) by xenotime.net for <linux-scsi@vger.kernel.org>; Wed, 21 Jun 2006 13:04:57 -0700
In-Reply-To: <4498A050.8080403@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org

On Tue, 20 Jun 2006 21:26:40 -0400 Douglas Gilbert wrote:

> James Bottomley wrote:
> > This represents the almost complete SCSI pending list apart from a SAS
> > port update which we're still trying to beat into shape.  The patch can
> > be pulled from here:
> > 
> > master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git
> > 
> > The short changelog is:
> 
> <snip>
> 
> James,
> I was hoping to see my scsi_debug update in there:
>   "[PATCH] scsi_debug version 1.79 against 2.6.17-rc5"
> 
> http://marc.theaimsgroup.com/?l=linux-scsi&m=114956710925458&w=2

Similarly, my patches for:

wd7000: fix section mismatches
  http://marc.theaimsgroup.com/?l=linux-scsi&m=114857569131744&w=2
qla1280: fix section mismatches
  http://marc.theaimsgroup.com/?l=linux-scsi&m=114857863523008&w=2
advansys: fix section mismatches
  http://marc.theaimsgroup.com/?l=linux-scsi&m=114982511005563&w=2

---
~Randy
