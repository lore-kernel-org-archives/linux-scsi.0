From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: [janitor] (1/5) aic7xyz: use kernel.h min/max/ARRAY_SIZE
Date: Mon, 03 May 2004 13:10:10 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <596965408.1083611410@aslan.scsiguy.com>
References: <20040427110417.6a7c35ff.rddunlap@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.scsiguy.com ([63.229.232.106]:46093 "EHLO
	aslan.scsiguy.com") by vger.kernel.org with ESMTP id S261221AbUECTKg
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 May 2004 15:10:36 -0400
In-Reply-To: <20040427110417.6a7c35ff.rddunlap@osdl.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: "Randy.Dunlap" <rddunlap@osdl.org>, scsi <linux-scsi@vger.kernel.org>
Cc: jejb <james.bottomley@steeleye.com>

> From: Michael Veeck <michael.veeck@gmx.net>
> Subject: [Kernel-janitors] [PATCH] drivers/scsi/aic7xxxx MIN/MAX/NUM_ELEMENTS
> 	removal
> 
> Patch (against 2.6.6-rc1) removes unnecessary min/max/num_elements 
> macros and changes calls to use kernel.h macros instead.

With the exception of two files, this patch changes the driver core.
These files must compile on several different OSes and thus must not
become dependent on Linux specific macros.

--
Justin

