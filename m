From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH v2] Fix leak in
 drivers/target/iscsi/iscsi_target_parameters.c::iscsi_copy_param_list()
Date: Mon, 01 Aug 2011 16:32:22 -0700
Message-ID: <1312241542.11635.21.camel@Joe-Laptop>
References: <alpine.LNX.2.00.1108010017030.28695@swampdragon.chaosbits.net>
	 <1312152274.11635.8.camel@Joe-Laptop>
	 <alpine.LNX.2.00.1108012230080.31999@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:4440 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753971Ab1HAXcZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Aug 2011 19:32:25 -0400
In-Reply-To: <alpine.LNX.2.00.1108012230080.31999@swampdragon.chaosbits.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jesper Juhl <jj@chaosbits.net>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Andy Grover <agrover@redhat.com>, Roland Dreier <roland@kernel.org>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, 2011-08-01 at 22:32 +0200, Jesper Juhl wrote:
> diff --git a/drivers/target/iscsi/iscsi_target_parameters.c b/drivers/target/iscsi/iscsi_target_parameters.c
[]
> @@ -572,6 +572,17 @@ int iscsi_copy_param_list(
[]
> +		if (!new_param->name || !new_param->value) {
[]
> +			pr_err("Unable to allocate memory for parameter "
> +				"name/value.\n");

I know you didn't change these lines, but could you please
remember to coalesce formats to a single line next time?

