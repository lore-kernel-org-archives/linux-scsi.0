From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [PATCH] scsi_transport_sas: add destructor for bsg
Date: Sat, 21 Jul 2007 01:51:35 +0900
Message-ID: <20070721013005K.tomof@acm.org>
References: <1184947805.3455.21.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:34796 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936581AbXGTQvs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Jul 2007 12:51:48 -0400
In-Reply-To: <1184947805.3455.21.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org

From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] scsi_transport_sas: add destructor for bsg
Date: Fri, 20 Jul 2007 11:10:05 -0500

> There's currently no destructor for the bsg components.  If you insert
> and remove the module, you see the bsg devices building up and up.  This
> patch adds the destructor in the correct place in the transport class so
> that the bsg and request queue are removed just before the device
> destruction.

Thanks. Sorry about the silly bug.
