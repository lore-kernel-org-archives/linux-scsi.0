From: Andrew Vasquez <praka@users.sourceforge.net>
Subject: Re: qla2xxx tcq question/bug
Date: Fri, 9 Jul 2004 16:54:43 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040709235443.GA14953@praka.san.rr.com>
References: <40EF2697.20804@us.ibm.com> <20040709234644.GB14787@praka.san.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-02-qfe0.socal.rr.com ([66.75.162.134]:44452 "EHLO
	ms-smtp-02-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S266013AbUGJAFt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Jul 2004 20:05:49 -0400
Content-Disposition: inline
In-Reply-To: <20040709234644.GB14787@praka.san.rr.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <mikenc@us.ibm.com>
Cc: andrew.vasquez@qlogic.com, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 09 Jul 2004, Andrew Vasquez wrote:

> On Fri, 09 Jul 2004, Mike Christie wrote:
> 
> > Should the qla2xx driver be calling
> > scsi_activate_tcq/scsi_populate_msg for devices that support tags,
> 
> I've taken a look through the ipr code (the only visible caller of
> scsi_populate_tag_msg()) -- looks like the qla driver has some
> problems here.
> 

BTW: 53c700.c appears to be the only scsi driver which calls
scsi_activate_tcq()???

--
Andrew Vasquez
