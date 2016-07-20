From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v4] libata-scsi: minor cleanup in ata_mselect_*()
Date: Wed, 20 Jul 2016 11:22:23 -0400
Message-ID: <20160720152223.GC4574@htj.duckdns.org>
References: <578e9008.4500420a.2d828.d131@mx.google.com>
 <578e979d.d40c620a.f5800.0924@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:35540 "EHLO
	mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752977AbcGTPW5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Jul 2016 11:22:57 -0400
Content-Disposition: inline
In-Reply-To: <578e979d.d40c620a.f5800.0924@mx.google.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tom.ty89@gmail.com
Cc: sergei.shtylyov@cogentembedded.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, Jul 20, 2016 at 05:11:50AM +0800, tom.ty89@gmail.com wrote:
> From: Tom Yan <tom.ty89@gmail.com>
> 
> 1. Removed a repeated bit masking in ata_mselect_control()
> 2. Moved `wce`/`d_sense` assignment below the page validity checks
> 3. Added/Removed empty lines where appropriate
> 
> Signed-off-by: Tom Yan <tom.ty89@gmail.com>

Applied to libata/for-4.8.

Thanks.

-- 
tejun
