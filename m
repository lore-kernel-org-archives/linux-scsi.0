From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 11/11] hpsa: fix rmmod issues
Date: Wed, 22 Jul 2015 17:20:12 +0200
Message-ID: <55AFB4AC.5090306@redhat.com>
References: <20150718160245.31955.16794.stgit@brunhilda>
 <20150718161315.31955.98302.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57412 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934564AbbGVPUP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Jul 2015 11:20:15 -0400
In-Reply-To: <20150718161315.31955.98302.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hp.com
Cc: linux-scsi@vger.kernel.org

On 18.7.2015 18:13, Don Brace wrote:
> The driver is calling hpsa_shutdown before calling scsi_remove_host.
> hpsa_shutdown is disabling interrupts.
> 
> scsi_remove_host can trigger I/O operations, such as
> SYNCHRONIZE CACHE when multipath is enabled which hang the system.
> 
> Call scsi_remove_host before calling hpsa_shutdown.
> 
> Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
> Signed-off-by: Don Brace <don.brace@pmcs.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas

