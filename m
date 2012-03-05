From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: WARNING: at block/genhd.c:1474 __disk_unblock_events+0xe1/0xf0()
 -- should I be concerned?
Date: Mon, 05 Mar 2012 17:56:33 +0000
Message-ID: <4F54FE51.1010401@acm.org>
References: <4F5379F5.6010604@msgid.tls.msk.ru> <4F545EB5.1070700@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay02ant.iops.be ([212.53.4.35]:43796 "EHLO
	relay02ant.iops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755153Ab2CER4i (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Mar 2012 12:56:38 -0500
In-Reply-To: <4F545EB5.1070700@msgid.tls.msk.ru>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On 03/05/12 06:35, Michael Tokarev wrote:
> [   22.635290] WARNING: at block/genhd.c:1474 __disk_unblock_events+0xe1/0xf0()

I've seen that warning message a few times myself, but no longer after
having applied this patch:*[PATCH] Fix NULL pointer dereference in
sd_revalidate_disk <http://marc.info/?t=113987361900002&r=1&w=2>*
(http://marc.info/?l=linux-kernel&m=132987267132047).

Bart.
