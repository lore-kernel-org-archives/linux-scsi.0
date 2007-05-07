From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [patch 18/30] Fix |/|| confusion in fusion driver
Date: Mon, 07 May 2007 14:55:05 -0500
Message-ID: <1178567705.3729.46.camel@mulgrave.il.steeleye.com>
References: <200704260735.l3Q7ZK79024259@shell0.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:43332 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754829AbXEGTzi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 May 2007 15:55:38 -0400
In-Reply-To: <200704260735.l3Q7ZK79024259@shell0.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: linux-scsi@vger.kernel.org, dmueller@osuse.de, eric.moore@lsi.com

On Thu, 2007-04-26 at 00:35 -0700, akpm@linux-foundation.org wrote:
> From: Dirk Mueller <dmueller@osuse.de>
> 
> This patch corrects a |/|| confusion in mptscsih_copy_sense_data.  Using ||
> means that the data that ends up being written is (almost always) 1,
> instead of being bit-wise or'ed.

Needs ack by maintainer.

James


