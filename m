From: Konrad Rzeszutek Wilk <konrad@darnok.org>
Subject: Re: [PATCH 1/1] Remove LUNs that no longer exist when we scan a target with REPORT LUNS.
Date: Mon, 16 Aug 2010 10:58:22 -0400
Message-ID: <201008161058.23562.konrad@darnok.org>
References: <1281917313-1855-1-git-send-email-realrichardsharpe@gmail.com> <201008160945.01369.konrad@darnok.org> <AANLkTi=mSgyGAK2NDnE-6bF5wG_FkX8mc6BsYwM5QpYt@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from andromeda.dapyr.net ([206.212.254.10]:37530 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754790Ab0HPRos (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Aug 2010 13:44:48 -0400
In-Reply-To: <AANLkTi=mSgyGAK2NDnE-6bF5wG_FkX8mc6BsYwM5QpYt@mail.gmail.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Richard Sharpe <realrichardsharpe@gmail.com>
Cc: linux-scsi@vger.kernel.org

> >> Tested by adding four LUNs with scst_local and then deleting them in
> >> various combinations, including deleting from LUN 0, deleting from last
> >> LUN and deleting in the middle out.
> >
> > What happens if you stack the device? Say you got multipath on top of
> > this or device-mapper? Does this work properly ? For multipath I would
> > expect it to work OK, and multipath device would queue the I/O until a
> > LUN with the same SCSI_ID would reappear.
>
> I do not know :-)
>
> Let me test this situation to find out.

Cool. Thanks.
