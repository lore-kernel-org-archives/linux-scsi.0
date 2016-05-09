From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] megaraid: add scsi_cmnd NULL check before use
Date: Mon, 9 May 2016 12:43:12 +0300
Message-ID: <20160509094311.GI29510@mwanda>
References: <1462668011.32105.7.camel@petros-ultrathin>
 <alpine.LNX.2.00.1605081235490.19865@nippy.intranet>
 <20160509080551.GH29510@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18989 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367AbcEIJn3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 May 2016 05:43:29 -0400
Content-Disposition: inline
In-Reply-To: <20160509080551.GH29510@mwanda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: Petros Koutoupis <petros@petroskoutoupis.com>, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com, uday.lingala@avagotech.com, megaraidlinux.pdl@avagotech.com, linux-scsi@vger.kernel.org

I've updated Smatch to catch these and I'm testing it now.  We'll see
how it goes.  If my quick and dirty method doesn't has too many false
positives then it's will take some months before I get around to doing
it properly...

Thanks for notifying me on this.

regards,
dan carpenter

