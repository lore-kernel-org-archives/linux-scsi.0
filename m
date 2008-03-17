From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: [patch 1/2] zfcp: Fix race during ERP thread shutdown
Date: Mon, 17 Mar 2008 15:29:53 +0100
Message-ID: <20080317142953.GA18412@schmichrtp.de.ibm.com>
References: <20080310151852.808020000@de.ibm.com> <20080310152328.463410000@de.ibm.com> <20080311164341.GA6380@osiris.boeblingen.de.ibm.com> <1205331227.4852.102.camel@kitka.ibm.com> <20080317141952.GA14110@schmichrtp.de.ibm.com> <1205763837.6767.125.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate6.de.ibm.com ([195.212.29.155]:18199 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbYCQO35 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Mar 2008 10:29:57 -0400
Content-Disposition: inline
In-Reply-To: <1205763837.6767.125.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, Martin Peschke <mp3@de.ibm.com>, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org

On Mon, Mar 17, 2008 at 09:23:57AM -0500, James Bottomley wrote:
> On Mon, 2008-03-17 at 15:19 +0100, Christof Schmitt wrote:
> > But this does not affect the patch in "[patch 2/2] zfcp: Fix handling
> > for boxed port after physical close". Could you pull this one into
> > scsi-misc?
> 
> Sure ... it's queued and I've dropped the other one.

Thanks.

Christof
