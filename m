From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 2/2] libata-scsi: rename ata_msense_ctl_mode() to
 ata_msense_control()
Date: Tue, 12 Jul 2016 15:04:21 -0400
Message-ID: <20160712190421.GA10377@htj.duckdns.org>
References: <20160712185412.4462-1-me>
 <57853cf8.c193420a.83221.11de@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f170.google.com ([209.85.192.170]:35068 "EHLO
	mail-pf0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbcGLTEY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jul 2016 15:04:24 -0400
Content-Disposition: inline
In-Reply-To: <57853cf8.c193420a.83221.11de@mx.google.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tom.ty89@gmail.com
Cc: hare@suse.de, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, Jul 13, 2016 at 02:54:12AM +0800, tom.ty89@gmail.com wrote:
> From: Tom Yan <tom.ty89@gmail.com>
> 
> To make it consistent with the recently added ata_mselect_control().
> We probably shouldn't have the word "mode" in its name anyway, since
> that's not the case for other ata_msense_*() / ata_mselect_*() either.
> 
> Signed-off-by: Tom Yan <tom.ty89@gmail.com>

Applied 1-2 to libata/for-4.8.

In the future, can you please link patches in the same series?  If
there are only several, either chain-replying or replying to the first
patch is fine.  If there are more, people usually write up a head
message and makes all patches replies to that message.

Thanks.

-- 
tejun
