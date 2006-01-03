From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: LSI Logic SAS1064 PCI-X Fusion-MPT SAS
Date: Tue, 3 Jan 2006 15:07:26 -0700
Message-ID: <F331B95B72AFFB4B87467BE1C8E9CF5F153491@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:29929 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S932530AbWACWHg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Jan 2006 17:07:36 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steffen Weber <email@steffenweber.net>
Cc: linux-scsi@vger.kernel.org

On Tuesday, January 03, 2006 3:00 PM,  Steffen Weber wrote:

> 
> Moore, Eric wrote:
> > Are the disks belonging to a RAID volume?
> Yes, they do! What does that mean for our situation?  :-)
> 

The RAID support is not there yet, and I'm working on it. Hopefully
in the next week.  I'm in dicussions with Christoph Hellwig on this.

Meanwhile, I suggest that you use the LSI internally supported drivers
which has RAID support. I will send that to you in a seperate email.

Eric Moore
