From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [PATCH 5/8] fusion - adding verbose messages for RAID actions
Date: Mon, 30 Jan 2006 15:17:51 -0600
Message-ID: <1138655871.3283.34.camel@mulgrave>
References: <F331B95B72AFFB4B87467BE1C8E9CF5F22118D@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:23213 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S965000AbWA3VSD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Jan 2006 16:18:03 -0500
In-Reply-To: <F331B95B72AFFB4B87467BE1C8E9CF5F22118D@NAMAIL2.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>
Cc: linux-scsi@vger.kernel.org

On Mon, 2006-01-30 at 12:28 -0700, Moore, Eric wrote:
> I didn't know that occurred on boot. I thought those messages only came
> when
> raid status change occured, such as a drive failing or volume coming
> online after resycn completed.

It's quiescing the RAID prior to performing Domain validation
(apparently we get three messages per quiesce: one for the array and one
each for the two halves of the mirror).

> What is your recommendation for this?

Perhaps use the KERN_ logging system to work for us:  so most array
event messages would be KERN_DEBUG that won't ordinarily display for the
less critical messages.

James


