From: "Steve Wise" <swise@opengridcomputing.com>
Subject: RE: [net-next 0/6] common library for Chelsio drivers
Date: Mon, 11 Jul 2016 14:55:11 -0500
Message-ID: <012801d1dbae$22288b90$6679a2b0$@opengridcomputing.com>
References: <cover.1467998292.git.varun@chelsio.com> <20160711.125021.1679165284508297380.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.opengridcomputing.com ([72.48.136.20]:50349 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750775AbcGKTzK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Jul 2016 15:55:10 -0400
In-Reply-To: <20160711.125021.1679165284508297380.davem@davemloft.net>
Content-Language: en-us
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'David Miller' <davem@davemloft.net>, varun@chelsio.com
Cc: netdev@vger.kernel.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, nab@linux-iscsi.org, gerlitz.or@gmail.com, james.bottomley@hansenpartnership.com, indranil@chelsio.com

> > Hi,
> >
> >  This patch series adds common library module(libcxgb.ko)
> > for Chelsio drivers to remove duplicate code.
> >
> > This series moves common iSCSI DDP Page Pod manager
> > code from cxgb4.ko to libcxgb.ko, earlier this code
> > was used by only cxgbit.ko now it is used by
> > three Chelsio iSCSI drivers cxgb3i, cxgb4i, cxgbit.
> >
> > In future this module will have common connection
> > management and hardware specific code that can
> > be shared by multiple Chelsio drivers(cxgb4,
> > csiostor, iw_cxgb4, cxgb4i, cxgbit).
> >
> > Please review.
> 
> As currently implemented the user is prompted for the Kconfig symbol
> for the library.  That really needs to be hidden from the user and
> they should be able to select these drivers without having to know
> about this implementation detail at all.

Maybe adding something like:

select CHELSIO_LIB

to the Kconfig files for the drivers that are depenedent on CHELSIO_LIB?


