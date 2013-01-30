From: Olaf Hering <olaf@aepfle.de>
Subject: Re: storvsc loops with No Sense messages
Date: Wed, 30 Jan 2013 10:59:48 +0100
Message-ID: <20130130095947.GA6626@aepfle.de>
References: <20130129152801.GA671@aepfle.de>
 <a120050e059c40c2a1d1be4eadc42dfd@SN2PR03MB061.namprd03.prod.outlook.com>
 <20130129185600.GA31738@aepfle.de>
 <05a4f02fe12545f489dd053175990b8d@SN2PR03MB061.namprd03.prod.outlook.com>
 <20130129212743.GA8052@aepfle.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:13315 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753726Ab3A3J77 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Jan 2013 04:59:59 -0500
Content-Disposition: inline
In-Reply-To: <20130129212743.GA8052@aepfle.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: KY Srinivasan <kys@microsoft.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Tue, Jan 29, Olaf Hering wrote:

> On Tue, Jan 29, KY Srinivasan wrote:
> 
> > Was the installation done on a vhd or VHDX. I checked with Hyper-V
> > guys and they say they never supported WRITE_SAME. I am wondering how
> > it worked on ws2008.
> 
> Its a vhdx image, both fixed and dynamically size have the same issue.
> I will see what happens with ws2008, at least the install proceeds
> without issues. 

I see that WRITE_SAME is also used when running on ws2008, but
appearently it does not cause any issues.
This triggers only when the default ext4 is used, not when I force ext3
for the root filesystem.
So to me it looks like ws2012 has issues with WRITE_SAME handling.


Is there a way to not use WRITE_SAME at all? While browsing the code its
not clear if there is a conditional for this command.


Olaf
