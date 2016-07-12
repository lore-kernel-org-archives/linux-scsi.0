From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2] libata-scsi: set correct VERSION field for ZAC devices
Date: Tue, 12 Jul 2016 10:47:01 -0400
Message-ID: <20160712144701.GC3190@htj.duckdns.org>
References: <5784fab7.1641620a.9a531.ffff8dae@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f170.google.com ([209.85.220.170]:33187 "EHLO
	mail-qk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769AbcGLOrF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jul 2016 10:47:05 -0400
Content-Disposition: inline
In-Reply-To: <5784fab7.1641620a.9a531.ffff8dae@mx.google.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tom.ty89@gmail.com
Cc: hare@suse.de, shaun.tancheff@seagate.com, sergei.shtylyov@cogentembedded.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, Jul 12, 2016 at 10:12:01PM +0800, tom.ty89@gmail.com wrote:
> From: Tom Yan <tom.ty89@gmail.com>
> 
> Commit 856c46639309 ("libata: support device-managed ZAC devices")
> had the line that "bumps" the VERSION field in standard INQUIRY data
> removed. Add it back and claim SPC-5 version compatibility, which
> matches with the current version descriptor "SPC-5 (no version claimed)"
> that is used for ZAC devices.
> 
> Signed-off-by: Tom Yan <tom.ty89@gmail.com>

Applied to libata/for-4.8.

Thanks.

-- 
tejun
