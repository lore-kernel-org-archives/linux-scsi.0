From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH V3 01/12] pm80xx: fix for memory region free
Date: Wed, 10 Apr 2013 12:15:09 -0700
Message-ID: <1365621309.1942.4.camel@dabdike>
References: <5149EFF9.6070604@pmc-sierra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:39739 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760498Ab3DJTPM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Apr 2013 15:15:12 -0400
In-Reply-To: <5149EFF9.6070604@pmc-sierra.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anand <anandkumar_santhanam@pmc-sierra.com>
Cc: linux-scsi@vger.kernel.org, Harry.Yang@pmcs.com, rich.Bono@pmcs.com, sakthivel.sk@hcl.com, Sangeetha.Gnanasekaran@pmcs.com, xjtuwjp@gmail.com, Vishwanath.Maram@pmcs.com

On Wed, 2013-03-20 at 10:20 -0700, Anand wrote:
> >From 700bfe79294e9f9e1a5def178af52b13928902a9 Mon Sep 17 00:00:00 2001
> From: Sakthivel K <Sakthivel.SaravananKamalRaju@pmcs.com>
> Date: Mon, 4 Feb 2013 12:10:02 +0530
> Subject: [PATCH V3 01/12] pm80xx: fix for memory region free

This one is already upstream:

commit bfb4809f7fff2f2db3d0de41ea4f49fd3f2f0aa4
Author: Sakthivel K <Sakthivel.SaravananKamalRaju@pmcs.com>
Date:   Mon Feb 4 12:10:02 2013 +0530

    [SCSI] pm80xx: fix for memory region free
 
James


