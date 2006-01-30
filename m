From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: [PATCH 5/8] fusion - adding verbose messages for RAID actions
Date: Mon, 30 Jan 2006 12:28:09 -0700
Message-ID: <F331B95B72AFFB4B87467BE1C8E9CF5F22118D@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:33528 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S964903AbWA3T2U convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Jan 2006 14:28:20 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

On Monday, January 30, 2006 12:22 PM,  James Bottomley wrote:

> I've put this in, but it really is quite verbose.  This is what my
> single IM RAID gives on boot:
> 

I didn't know that occurred on boot. I thought those messages only came
when
raid status change occured, such as a drive failing or volume coming
online after resycn completed.

> 
> Which is rather a lot of spew for a single device ...
> 

What is your recommendation for this?
