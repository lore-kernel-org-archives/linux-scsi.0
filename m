From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: buslogic-update.patch
Date: 29 Dec 2003 09:14:44 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1072710886.2123.1.camel@mulgrave>
References: <20031229033515.32bc0576.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:33968 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263527AbTL2POv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Dec 2003 10:14:51 -0500
In-Reply-To: <20031229033515.32bc0576.akpm@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: "Randy.Dunlap" <rddunlap@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2003-12-29 at 05:35, Andrew Morton wrote:
> James, can I unload this on you?   Thanks.

This one's already in my scsi-misc-2.7 tree (since 17 Dec) as

ChangeSet@1.1530.1.4, 2003-12-17 15:25:00-05:00, rddunlap@osdl.org
  [PATCH] buslogic: use EH, remove some dup. docs


James


