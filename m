From: Olaf Hering <olaf@aepfle.de>
Subject: Re: storvsc loops with No Sense messages
Date: Tue, 29 Jan 2013 22:27:43 +0100
Message-ID: <20130129212743.GA8052@aepfle.de>
References: <20130129152801.GA671@aepfle.de>
 <a120050e059c40c2a1d1be4eadc42dfd@SN2PR03MB061.namprd03.prod.outlook.com>
 <20130129185600.GA31738@aepfle.de>
 <05a4f02fe12545f489dd053175990b8d@SN2PR03MB061.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:55854 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949Ab3A2V1x (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Jan 2013 16:27:53 -0500
Content-Disposition: inline
In-Reply-To: <05a4f02fe12545f489dd053175990b8d@SN2PR03MB061.namprd03.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: KY Srinivasan <kys@microsoft.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Tue, Jan 29, KY Srinivasan wrote:

> Was the installation done on a vhd or VHDX. I checked with Hyper-V
> guys and they say they never supported WRITE_SAME. I am wondering how
> it worked on ws2008.

Its a vhdx image, both fixed and dynamically size have the same issue.
I will see what happens with ws2008, at least the install proceeds
without issues. 


Also the unpatched kernel works fine in the installed system.

Olaf
