From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [patchset 0/24] Lots of the Accessors patches and !use_sg cleanup
Date: Wed, 12 Sep 2007 00:05:06 +0300
Message-ID: <46E70302.5040307@panasas.com>
References: <46E6F92D.2090409@panasas.com> <558F4D473FD7FE419B019232BF2D37B4011680E8@G3W0634.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:2512 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754898AbXIKVFL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Sep 2007 17:05:11 -0400
In-Reply-To: <558F4D473FD7FE419B019232BF2D37B4011680E8@G3W0634.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Cameron, Steve" <Steve.Cameron@hp.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Tue, Sep 11 2007 at 23:50 +0300, "Cameron, Steve" <Steve.Cameron@hp.com> wrote:
> drivers/block/cciss_scsi.c

Already done by Tomo
41ce639a1c50cb936f058f52f99f65740e3f550e 
  cciss: convert to use the data buffer accessors
