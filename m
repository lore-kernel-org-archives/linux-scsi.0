From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v2] scsi: megaraid: check kzalloc
Date: Tue, 04 Jun 2013 14:14:28 +0200
Message-ID: <51ADDA24.7050609@redhat.com>
References: <519ECEF1.9060804@huawei.com> <519F3592.4090207@huawei.com> <51ADB484.3060404@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55724 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751906Ab3FDMOi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Jun 2013 08:14:38 -0400
In-Reply-To: <51ADB484.3060404@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Libo Chen <libo.chen@huawei.com>
Cc: megaraidlinux@lsi.com, JBottomley@parallels.com, Libo Chen <chenlibo.3@gmail.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, kashyap.desai@lsi.com, aradford@gmail.com, Li Zefan <lizefan@huawei.com>, Santosh Y <santoshsy@gmail.com>

On 06/04/2013 11:33 AM, Libo Chen wrote:
> we should check kzalloc, avoid to hit oops
>
> Change from v1:
> - put kzalloc outside of mutex
>
> Signed-off-by: Libo Chen <libo.chen@huawei.com>

Your patch looks fine to me:
Acked-by: Tomas Henzl <thenzl@redhat.com>

Cheers,
Tomas

