From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 6/8] target: remove the unused type field in struct
	se_subsystem_api
Date: Tue, 23 Nov 2010 18:36:27 -0800
Message-ID: <1290566187.30138.173.camel@haakon2.linux-iscsi.org>
References: <20101123223053.574330460@bombadil.infradead.org>
	 <20101123223110.692950619@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:54292 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083Ab0KXClz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Nov 2010 21:41:55 -0500
In-Reply-To: <20101123223110.692950619@bombadil.infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

On Tue, 2010-11-23 at 17:30 -0500, Christoph Hellwig wrote:
> plain text document attachment (lio-kill-subsystem-type)
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 

Looks good, committed as da0ebe270d with the following message:

"Remove the now unused se_subsystem_api->type field left over from
 the pre configfs control plane dark ages."

Thanks!

--nab


