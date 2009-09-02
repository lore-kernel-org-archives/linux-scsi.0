From: Jing Huang <huangj@Brocade.COM>
Subject: RE: [PATCH 1/14] bfa: Brocade BFA FC SCSI driver (bfad)
Date: Wed, 2 Sep 2009 13:02:07 -0700
Message-ID: <B0A7AF226B49A14897036E9B3A68CFFECB1AA834E5@HQ-EXCH-7.corp.brocade.com>
References: <200908280754.n7S7sUMB030191@blc-10-6.brocade.com>
 <20090902124135.aa55f0be.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hq-exedge.brocade.com ([66.243.153.82]:21438 "EHLO
	hq-exedge.brocade.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462AbZIBUCG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Sep 2009 16:02:06 -0400
In-Reply-To: <20090902124135.aa55f0be.akpm@linux-foundation.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Ramkumar Vadivelu <rvadivel@Brocade.COM>, Vinodh Ravindran <vravindr@Brocade.COM>

> These patches seem to have been posted a lot of times.  Is anyone
> paying attention?
> 
> > +BFA_TRC_FILE(LDRV, BFAD);
> > +
> > +static DEFINE_MUTEX(bfad_mutex);
> > +int bfad_scan_done;
> > +
> > +LIST_HEAD(bfad_list);
> > +
> > +static int      bfad_inst;
> > +int             supported_fc4s;
> > +
> > +char           *host_name;
> > +char           *os_name;
> > +char           *os_patch;
> > +int             num_rports;
> > +int             num_ios;
> > +int             num_tms;
> > +int             num_fcxps;
> > +int             num_ufbufs;
> > +int             reqq_size;
> > +int             rspq_size;
> > +int             num_sgpgs;
> > +int             rport_del_timeout = BFA_FCS_RPORT_DEF_DEL_TIMEOUT;
> > +int             bfa_lun_queue_depth = BFAD_LUN_QUEUE_DEPTH;
> > +int             bfa_io_max_sge = BFAD_IO_MAX_SGE;
> > +int             log_level = BFA_LOG_WARNING;
> > +int             ioc_auto_recover = BFA_TRUE;
> > +int             ipfc_enable = BFA_FALSE;
> > +int             ipfc_mtu = -1;
> > +int             linkup_delay = -1;
> 
> eek.  These are all kernel-wide global symbols and many of them are
> very inappropriately named.  They should either be made static or given
> a subsystem-specific prefix such as "bfad_".
> 

Thanks Andrew. I will fix this and resubmit.

