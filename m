From: "Robert Tarte" <robt@PacificCodeWorks.com>
Subject: RE: [RFC] aic94xx: attaching to the sas transport class
Date: Fri, 3 Mar 2006 08:39:12 -0800
Message-ID: <16C8363E16D7234AB844FDB52D4AEA6529BB@ntserv.PacificCodeWorks.local>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from h-67-101-118-101.snfccasy.covad.net ([67.101.118.101]:28507
	"EHLO PacificCodeWorks.com") by vger.kernel.org with ESMTP
	id S932305AbWCCQjQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2006 11:39:16 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>, James Bottomley <James.Bottomley@SteelEye.com>
Cc: ltuikov@yahoo.com, "Tarte, Robert" <Robert_Tarte@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>

-Original Message-----
> James Bottomley wrote:
> > Assuming the cages are all powered up, which is beyond
> > the driver control, then serialising the scan will allow one to
> > specify /dev/sda1 deterministically for root.
> 
> Does SAS provide a persistent globally unique property of a device, or
> has SAS to rely on bus topology to uniqely identify devices?

SAS devices have world wide names.


