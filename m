From: David Miller <davem@davemloft.net>
Subject: Re: HELP: Is writeq an atomic operation??
Date: Fri, 02 May 2008 15:32:10 -0700 (PDT)
Message-ID: <20080502.153210.122414532.davem@davemloft.net>
References: <0631C836DBF79F42B5A60C8C8D4E822901047B1D@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41145
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758278AbYEBWcK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 May 2008 18:32:10 -0400
In-Reply-To: <0631C836DBF79F42B5A60C8C8D4E822901047B1D@NAMAIL2.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric.Moore@lsi.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

From: "Moore, Eric" <Eric.Moore@lsi.com>
Date: Fri, 2 May 2008 16:19:49 -0600

> Is a 64bit write to MMIO registers an atomic operation when using the
> writeq API?  

The answer to this question this is platform dependent.

On most 64-bit platforms, it is.  On some 32-bit ones, it is not.

This is not a SCSI layer question, so belongs minimally on
linux-kernel which I've CC:'d.
