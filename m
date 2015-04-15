From: Andy Grover <agrover@redhat.com>
Subject: Re: [RFC PATCH 2/2] lpfc: add target hooks
Date: Tue, 14 Apr 2015 17:25:04 -0700
Message-ID: <552DAFE0.7050109@redhat.com>
References: <20150412161740.00001d41@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37884 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751768AbbDOAZG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Apr 2015 20:25:06 -0400
In-Reply-To: <20150412161740.00001d41@localhost>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sebastian Herbszt <herbszt@gmx.de>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, James Smart <james.smart@emulex.com>

On 04/12/2015 07:17 AM, Sebastian Herbszt wrote:
> Add target hooks.
>
> Signed-off-by: Sebastian Herbszt <herbszt@gmx.de>

> +#ifdef LPFC_TARGET_MODE
> +#include "lpfc_target_api.h"
> +#include "lpfc_target_api_base.h"
> +#endif

Hi, great to see new fabrics posted.

There are a great many ifdefs like this. Are they strictly necessary?

Thanks -- Regards -- Andy

