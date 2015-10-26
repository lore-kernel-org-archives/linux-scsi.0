From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 04/21] hpsa: correct transfer length for 6 byte read/write
 commands
Date: Mon, 26 Oct 2015 15:37:26 +0100
Message-ID: <562E3AA6.8040602@redhat.com>
References: <20151024193306.17127.7819.stgit@brunhilda>
 <20151024195250.17127.75934.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34311 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753924AbbJZOh3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Oct 2015 10:37:29 -0400
In-Reply-To: <20151024195250.17127.75934.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

On 24.10.2015 21:52, Don Brace wrote:
> handle block counts of 0. Cleanup block and block count calculations.
>
> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
> Reviewed-by: Justin Lindley <justin.lindley@pmcs.com>
> Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
> Signed-off-by: Don Brace <don.brace@pmcs.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas

