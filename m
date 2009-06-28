From: "Michael Chan" <mchan@broadcom.com>
Subject: Re: [PATCH 1/3] bnx2i remove not so useful global variable
 bnx2i_reg_devices
Date: Sun, 28 Jun 2009 08:46:59 -0700
Message-ID: <C27F8246C663564A84BB7AB343977242178EE7808C@IRVEXCHCCR01.corp.ad.broadcom.com>
References: <1246199631.4190.7.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1351 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753368AbZF1Pr2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Jun 2009 11:47:28 -0400
In-Reply-To: <1246199631.4190.7.camel@mulgrave.site>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <James.Bottomley@HansenPartnership.com>, Anil Veerabhadrappa <anilgv@broadcom.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>

James Bottomley wrote:

> On Tue, 2009-06-23 at 18:11 -0700, Anil Veerabhadrappa wrote:
> > >From a8267738e9ca5c73ad6c0d89f17cf864bfc908c8 Mon Sep 17
> 00:00:00 2001
> > From: Anil Veerabhadrappa <anilgv@broadcom.com>
> > Date: Tue, 23 Jun 2009 13:56:29 -0700
> > Subject: [PATCH]     bnx2i - remove global variable
> bnx2i_reg_devices
> >
> >     * Removed bnx2i_reg_devices as this counter is not really
> >       used in a meaningful way
> >     Cc: Mike Christie <michaelc@cs.wisc.edu>
> >
> > Signed-off-by: Michael Chan <mchan@broadcom.com>
> > Signed-off-by: Anil Veerabhadrappa <anilgv@broadcom.com>
>
> Tell me what these signoffs mean:  The first signoff by Michael Chan
> implies it's his patch, but it has your authorship information.
>

Sorry, Anil should have put his signoff first.  Do we need to re-spin
the pacthes?

