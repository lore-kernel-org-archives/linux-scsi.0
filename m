From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: [PATCH 3/6] mpt fusion: Changing call back indices to u8 from int
Date: Tue, 14 Aug 2007 10:17:41 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D709166CC@NAMAIL4.ad.lsil.com>
References: <20070814104253.GC9944@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:60221 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760490AbXHNQRo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Aug 2007 12:17:44 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20070814104253.GC9944@lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Prakash, Sathya" <Sathya.Prakash@lsi.com>, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

On  Tuesday, August 14, 2007 4:43 AM, Prakash, Sathya wrote:
> 
> The call back index requires only u8 but in lot of places it 
> is referred as int, now everywhere the call back index 
> variables are declared as u8 with uniform name cb_idx
> 
> signed-off-by: Sathya Prakash <sathya.prakash@lsi.com>
> ---
> 

Pls note we killed both mpt_lan_index and mpt_stm_index, external
symbols, which the janitors have long wanted to remove.  The new
function mpt_get_cb_idx will obtain the proper cb_idx handle. 

ACK

