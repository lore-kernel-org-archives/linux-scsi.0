From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH 2/2] scsi: qla2xxx: print MAC via %pMR
Date: Tue, 28 May 2013 11:44:42 +0300
Message-ID: <1369730682.29283.220.camel@smile>
References: <1342079490-20191-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1342079490-20191-2-git-send-email-andriy.shevchenko@linux.intel.com>
	 <alpine.WNT.2.00.1207260822340.4880@N5102REMCQXM4BS.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:29840 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933607Ab3E1Ios convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 28 May 2013 04:44:48 -0400
In-Reply-To: <alpine.WNT.2.00.1207260822340.4880@N5102REMCQXM4BS.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chad Dupuis <chad.dupuis@qlogic.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-driver@qlogic.com, "James E.J. Bottomley" <JBottomley@parallels.com>

On Thu, 2012-07-26 at 08:23 -0400, Chad Dupuis wrote: 
> 
> On Thu, 12 Jul 2012, Andy Shevchenko wrote:
> 
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > ---
> > drivers/scsi/qla2xxx/qla_attr.c |    5 +----
> > 1 file changed, 1 insertion(+), 4 deletions(-)
> >
> > diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
> > index 5ab9530..095ba85 100644
> > --- a/drivers/scsi/qla2xxx/qla_attr.c
> > +++ b/drivers/scsi/qla2xxx/qla_attr.c
> > @@ -1193,10 +1193,7 @@ qla2x00_vn_port_mac_address_show(struct device *dev,
> >       if (!IS_CNA_CAPABLE(vha->hw))
> >               return snprintf(buf, PAGE_SIZE, "\n");
> >
> > -     return snprintf(buf, PAGE_SIZE, "%02x:%02x:%02x:%02x:%02x:%02x\n",
> > -         vha->fcoe_vn_port_mac[5], vha->fcoe_vn_port_mac[4],
> > -         vha->fcoe_vn_port_mac[3], vha->fcoe_vn_port_mac[2],
> > -         vha->fcoe_vn_port_mac[1], vha->fcoe_vn_port_mac[0]);
> > +     return snprintf(buf, PAGE_SIZE, "%pMR\n", vha->fcoe_vn_port_mac);
> > }
> >
> > static ssize_t
> >
> 
> Acked-by: Chad Dupuis <chad.dupuis@qlogic.com>


James, do you have any comments on this patch and patch 1/2?

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
