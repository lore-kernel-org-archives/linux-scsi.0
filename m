From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v4 29/43] hpsa: refactor and rework support for sending
 TEST_UNIT_READY
Date: Fri, 17 Apr 2015 15:43:32 +0200
Message-ID: <55310E04.1050500@redhat.com>
References: <20150416134224.30238.66082.stgit@brunhilda> <20150416134920.30238.52473.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36279 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753362AbbDQNoB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Apr 2015 09:44:01 -0400
In-Reply-To: <20150416134920.30238.52473.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.combrace@pmcs.com
Cc: linux-scsi@vger.kernel.org

On 04/16/2015 03:49 PM, Don Brace wrote:
> From: Webb Scales <webbnh@hp.com>
>
> Factor out the code which sends the TEST_UNIT_READY from
> wait_for_device_to_become_ready() into its own function.
>
> Move the code which waits for the TEST_UNIT_READY from
> wait_for_device_to_become_ready() into its own function.
>
> If a logical drive has failed, resetting it will ensure
> outstanding commands are completed, but polling it with
> TURs after the reset will not work because the TURs will
> never report good status.  So successful TUR should not
> be a condition of success for the device reset error
> handler.
>
> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
> Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
> Signed-off-by: Webb Scales <webbnh@hp.com>
> Signed-off-by: Don Brace <don.brace@pmcs.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas


