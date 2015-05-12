From: "Winkler, Tomas" <tomas.winkler@intel.com>
Subject: RE: [scsi 2/2] scsi_debug: fix REPORT LUNS Well Known LU
Date: Tue, 12 May 2015 07:56:01 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B355C9A39@hasmsx108.ger.corp.intel.com>
References: <1424690001-2482-1-git-send-email-tomas.winkler@intel.com>
 <1424690001-2482-2-git-send-email-tomas.winkler@intel.com>
 <54EB7160.50600@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:34721 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753091AbbELH4M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 May 2015 03:56:12 -0400
In-Reply-To: <54EB7160.50600@interlog.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "dgilbert@interlog.com" <dgilbert@interlog.com>, "James E.J. Bottomley\"" <JBottomley@parallels.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>


 
> On 15-02-23 06:13 AM, Tomas Winkler wrote:
> > The use case to report 'REPORT LUNS WLUN' described
> > in scsi_debug documentation didn't work because:
> > scsi_scan_host_selected() checks for:
> > 	 lun < shost->max_lun
> >
> > To fix this we set:
> > 	max_lun = SCSI_W_LUN_REPORT_LUNS + 1;
> >
> > Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> 
> Acked-by: Douglas Gilbert <dgilbert@interlog.com>
> 
Is anyone picking up this changes ? 
What is the review process on the scsi list
Thanks
Tomas

