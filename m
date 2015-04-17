From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v4 39/43] hpsa: propagate the error code in hpsa_kdump_soft_reset
Date: Fri, 17 Apr 2015 15:51:15 +0200
Message-ID: <55310FD3.2040603@redhat.com>
References: <20150416134224.30238.66082.stgit@brunhilda> <20150416135014.30238.10423.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965488AbbDQNvm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Apr 2015 09:51:42 -0400
In-Reply-To: <20150416135014.30238.10423.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.combrace@pmcs.com
Cc: linux-scsi@vger.kernel.org

On 04/16/2015 03:50 PM, Don Brace wrote:
> From: Robert Elliott <elliott@hp.com>
>
> If hpsa_wait_for_board_state fails, hpsa_kdump_soft_reset
> should propagate its return value (e.g., -ENODEV) rather
> than just returning -1.
>
> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
> Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
> Signed-off-by: Robert Elliott <elliott@hp.com>
> Signed-off-by: Don Brace <don.brace@pmcs.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas


