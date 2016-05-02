From: "Winkler, Tomas" <tomas.winkler@intel.com>
Subject: RE: [PATCH v2.5 2/6] scsi_debug: rework resp_report_luns
Date: Mon, 2 May 2016 08:29:26 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B54255250@hasmsx108.ger.corp.intel.com>
References: <1462070687-12689-1-git-send-email-dgilbert@interlog.com>
 <1462070687-12689-3-git-send-email-dgilbert@interlog.com>
 <57270EF0.2070604@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:26396 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751500AbcEBI3b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 May 2016 04:29:31 -0400
In-Reply-To: <57270EF0.2070604@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Douglas Gilbert <dgilbert@interlog.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "emilne@redhat.com" <emilne@redhat.com>, "bart.vanassche@sandisk.com" <bart.vanassche@sandisk.com>



> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]
> Sent: Monday, May 02, 2016 11:25
> To: Douglas Gilbert <dgilbert@interlog.com>; linux-scsi@vger.kernel.org
> Cc: martin.petersen@oracle.com; Winkler, Tomas
> <tomas.winkler@intel.com>; emilne@redhat.com;
> bart.vanassche@sandisk.com
> Subject: Re: [PATCH v2.5 2/6] scsi_debug: rework resp_report_luns
> 
> On 05/01/2016 04:44 AM, Douglas Gilbert wrote:
> > Based on "[PATH V2] scsi_debug: rework resp_report_luns" patch sent by
> > Tomas Winkler on Thursday, 26 Feb 2015. His notes:
> >   1. Remove duplicated boundary checks which simplify the fill-in
> >      loop
> >   2. Use more of scsi generic API
> > Replace fixed length response array a with heap allocation allowing up
> > to 256 normal LUNs per target.
> >
> > Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
> > ---
> >  drivers/scsi/scsi_debug.c | 135
> > +++++++++++++++++++++++++++++-----------------
> >  1 file changed, 87 insertions(+), 48 deletions(-)
> >
> Reviewed-by: Hannes Reinecke <hare@suse.com>
Ack again 

