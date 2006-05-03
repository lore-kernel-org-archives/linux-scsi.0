From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [PATCH] fusion - race between mptfc_register_dev and
	mptfc_target_alloc
Date: Wed, 03 May 2006 13:08:57 -0500
Message-ID: <1146679737.3346.77.camel@mulgrave.il.steeleye.com>
References: <664A4EBB07F29743873A87CF62C26D700C6921@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:15789 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751322AbWECSJD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 May 2006 14:09:03 -0400
In-Reply-To: <664A4EBB07F29743873A87CF62C26D700C6921@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>
Cc: mdr@sgi.com, linux-scsi@vger.kernel.org, jeremy@sgi.com, gwh@sgi.com

On Mon, 2006-05-01 at 12:10 -0600, Moore, Eric wrote:
> On Monday, May 01, 2006 12:07 PM, Micheal Reed wrote: 
> > This patch applies to 2.6.17-rc3 after applying these patches from
> > scsi-rc-fixes-2.6.git.
> > 
> >    [SCSI] mptfusion: bug fix's for raid components adding/deleting
> >    [SCSI] - fusion - mptfc bug fix's to prevent deadlock situations
> >    [SCSI] fusion - bug fix stack overflow in mptbase

Is there an Ack for this patch?

James


