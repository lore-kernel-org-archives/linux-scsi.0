From: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: PATCH [2/5]  qla2xxx: add remote port codes...
Date: Fri, 27 May 2005 00:51:19 -0700
Message-ID: <20050527075118.GB51419@sgi.com>
References: <20050413191548.GI9703@plap.qlogic.org> <20050413191824.GK9703@plap.qlogic.org> <20050413214023.GA18161@infradead.org> <20050419072751.GD5999@plap.qlogic.org> <20050520061736.GA11551@sgi.com> <20050520151542.GA17419@plap.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx3-ext.sgi.com ([192.48.171.20]:28116 "EHLO omx3.sgi.com")
	by vger.kernel.org with ESMTP id S261966AbVE0Hvb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 May 2005 03:51:31 -0400
Content-Disposition: inline
In-Reply-To: <20050520151542.GA17419@plap.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>

On Fri, May 20, 2005 at 08:15:42AM -0700, Andrew Vasquez wrote:
> On Thu, 19 May 2005, Jeremy Higdon wrote:
> 
> > On Tue, Apr 19, 2005 at 12:27:51AM -0700, Andrew Vasquez wrote:
> > 
> > In fact, it seems to break probing for luns other than zero.
> > 
> > You initialize ha->max_luns in qla2x00_nvram_config(), which is called form
> > qla2x00_initialize_adapter().  So we're currently seeing messages like
> > this during ISP2312 initialization:
> > 
> > <4>scsi: host 1 channel 0 id 0 lun1 has a LUN larger than allowed by the host adapter
> 
> Jeremy, could you try this patch out.
> 
> James, please apply.
> 
> 
> [PATCH] Pull-down scsi-host-addition to follow board initialization.
> 
> Return to previous held-logic of calling scsi_add_host() only after
> the board has been completely initialized.  Also return pci_*()
> error-codes during probe failure paths.


Thanks Andrew,

This patch took care of the problem.

jeremy
