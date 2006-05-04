From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: [PATCH] fusion - race between mptfc_register_dev and mptfc_target_alloc
Date: Thu, 4 May 2006 08:46:26 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D700C704A@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:37365 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1751489AbWEDOqf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 May 2006 10:46:35 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: mdr@sgi.com, linux-scsi@vger.kernel.org, jeremy@sgi.com, gwh@sgi.com

On Wednesday, May 03, 2006 12:09 PM, James Bottomley wrote:  
> 
> On Mon, 2006-05-01 at 12:10 -0600, Moore, Eric wrote:
> > On Monday, May 01, 2006 12:07 PM, Micheal Reed wrote: 
> > > This patch applies to 2.6.17-rc3 after applying these patches from
> > > scsi-rc-fixes-2.6.git.
> > > 
> > >    [SCSI] mptfusion: bug fix's for raid components adding/deleting
> > >    [SCSI] - fusion - mptfc bug fix's to prevent deadlock 
> situations
> > >    [SCSI] fusion - bug fix stack overflow in mptbase
> 
> Is there an Ack for this patch?

ACK
