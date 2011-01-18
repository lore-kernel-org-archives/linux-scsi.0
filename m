From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] target_core_mib.h move
Date: Tue, 18 Jan 2011 15:15:46 -0500
Message-ID: <20110118201546.GA15970@infradead.org>
References: <AANLkTim-KKyOt_U2cDvfW3cav9F29mSvzAcV9H2mJqbT@mail.gmail.com>
 <20110117205130.GA22532@infradead.org>
 <AANLkTinNiohS+9WDcCP4P=0beRRE53x4iFC9u7iXBOy2@mail.gmail.com>
 <1295381563.22813.429.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:35015 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647Ab1ARUPr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Jan 2011 15:15:47 -0500
Content-Disposition: inline
In-Reply-To: <1295381563.22813.429.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Fubo Chen <fubo.chen@gmail.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, Jan 18, 2011 at 12:12:43PM -0800, Nicholas A. Bellinger wrote:
> EXTRA_CFLAGS += -I$(srctree)/drivers/target/ -I$(srctree)/include/ -I$(srctree)/drivers/scsi/ -I$(srctree)/include/scsi/ -I$(srctree)/drivers/target/tcm_mvsas_tgt
> 
> FYI, depending upon the age of the tcm_mod_builder.py in question , you
> may want to consider re-generating the fabric module skeleton with the
> latest code.

This shouldn't be nessecary.  Except for special cases driver should
never need special include paths.  I still don't see why the mib header
should be needed by drivers, but if it is it needs to move under
include/. 

