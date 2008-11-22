From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: Question regarding SAS controllers.
Date: Sat, 22 Nov 2008 14:51:23 -0700
Message-ID: <660360F4F2570145BD872F298951B17A5CC40737@cosmail03.lsi.com>
References: <alpine.DEB.1.10.0811221645250.707@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og103.obsmtp.com ([64.18.2.159]:37428 "EHLO
	exprod7og103.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486AbYKVWLt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 22 Nov 2008 17:11:49 -0500
In-Reply-To: <alpine.DEB.1.10.0811221645250.707@p34.internal.lan>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Alan Piszcz <ap@solarrain.com>

On Saturday, November 22, 2008 2:47 PM, Justin Piszcz wrote:

> Do any SAS controllers exist that are not RAID?
>
> Or to put it another way, if one wants to use SAS disks for
> example and
> NOT export them as JBOD or use them as RAID, is there a
> normal controller?
>
> Back in the days of regular SCSI you had SCSI controllers and
> SCSI raid
> controllers, when searching for SAS controllers now, all that
> comes up is
> hundreds of SAS-Raid controllers.
>

mptsas

http://www.lsi.com/storage_home/products_home/host_bus_adapters/sas_hbas/index.html

Eric Moore
