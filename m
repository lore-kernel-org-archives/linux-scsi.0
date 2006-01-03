From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: qla2300 & mptscsih refcount, or lack thereof
Date: Tue, 3 Jan 2006 15:03:23 -0700
Message-ID: <F331B95B72AFFB4B87467BE1C8E9CF5F15348C@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:49384 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1751030AbWACWDi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Jan 2006 17:03:38 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

On Tuesday, January 03, 2006 12:18 PM, Patrick Mansfield wrote: 

> snip....

> We probably need to duplicate the .module in struct scsi_host, set it
> appropriately (by default copy struct scsi_host_template 
> value), and then
> use it in scsi_device_get().
> 
> I haven't looked at mptspi drivers.
> 
> -- Patrick Mansfield
> 

There is a patch I posted about a month ago having .module=THIS_MODULE,
in the mptspi.c source.   James Bottomley posted earlier today in
my "Eric Moore" section regarding this.  I believe that is all that is
required
for reference counting, right?  If not, pls let me know.

JB - URL:
http://marc.theaimsgroup.com/?l=linux-scsi&m=113630625920693&w=2

Eric Moore
