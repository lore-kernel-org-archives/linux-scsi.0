From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH] esas2r: Fix array overrun
Date: Tue, 16 Feb 2016 13:24:35 +0100
Message-ID: <56C31503.9060805@redhat.com>
References: <20160215190123.11294.22634.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39978 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754764AbcBPMYh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Feb 2016 07:24:37 -0500
In-Reply-To: <20160215190123.11294.22634.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan <gnomes@lxorguk.ukuu.org.uk>, linux-scsi@vger.kernel.org

On 15.2.2016 20:01, Alan wrote:
> Check the array size *before* dereferencing it with a user provided offset
>
> Signed-off-by: Alan Cox <alan@linux.intel.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas

