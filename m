From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v4 38/43] hpsa: use scsi host_no as hpsa controller number
Date: Fri, 17 Apr 2015 15:50:59 +0200
Message-ID: <55310FC3.7070906@redhat.com>
References: <20150416134224.30238.66082.stgit@brunhilda> <20150416135009.30238.8580.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38933 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965470AbbDQNv1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Apr 2015 09:51:27 -0400
In-Reply-To: <20150416135009.30238.8580.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.combrace@pmcs.com
Cc: linux-scsi@vger.kernel.org

On 04/16/2015 03:50 PM, Don Brace wrote:
> From: Robert Elliott <elliott@hp.com>
>
> Rather than numbering the hpsa controllers with an
> incrementing 0..n value (e.g., that shows up in
> /proc/interrupts), use the scsi midlayer
> host_no (e.g. matching /sys/class/scsi_host/hostNN).
>
> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
> Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
> Signed-off-by: Robert Elliott <elliott@hp.com>
> Signed-off-by: Don Brace <don.brace@pmcs.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas

