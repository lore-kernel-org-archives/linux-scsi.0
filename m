From: Roland Dreier <rdreier@cisco.com>
Subject: Re: HELP: Is writeq an atomic operation??
Date: Fri, 02 May 2008 15:43:32 -0700
Message-ID: <adaabj8499n.fsf@cisco.com>
References: <0631C836DBF79F42B5A60C8C8D4E822901047B1D@NAMAIL2.ad.lsil.com>
	<20080502.153210.122414532.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-6.cisco.com ([171.71.176.117]:51530 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755532AbYEBWnp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 May 2008 18:43:45 -0400
In-Reply-To: <20080502.153210.122414532.davem@davemloft.net> (David Miller's
	message of "Fri, 02 May 2008 15:32:10 -0700 (PDT)")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: Eric.Moore@lsi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

 > > Is a 64bit write to MMIO registers an atomic operation when using the
 > > writeq API?  
 > 
 > The answer to this question this is platform dependent.
 > 
 > On most 64-bit platforms, it is.  On some 32-bit ones, it is not.

Are there any 32-bit platforms with writeq()?  A quick grep suggests not.

Are there any 64-bit platforms where writeq() allows the MMIO to be
split into multiple cycles from the target device's view?  I've been
coding assuming that at least no other MMIO writes will reach the device
in the middle of a writeq().

 - R.
