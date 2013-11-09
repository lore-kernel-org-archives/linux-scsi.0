From: Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH 2/5] arm64: Add APM X-Gene SATA DTS binding
Date: Fri, 8 Nov 2013 16:39:19 -0800
Message-ID: <20131109003919.GB22982@quad.lixom.net>
References: <1383949838-25106-1-git-send-email-lho@apm.com>
 <1383949838-25106-2-git-send-email-lho@apm.com>
 <1383949838-25106-3-git-send-email-lho@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:39686 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757227Ab3KIAlp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Nov 2013 19:41:45 -0500
Received: by mail-pa0-f44.google.com with SMTP id fb1so2947895pad.3
        for <linux-scsi@vger.kernel.org>; Fri, 08 Nov 2013 16:41:44 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1383949838-25106-3-git-send-email-lho@apm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Loc Ho <lho@apm.com>
Cc: tj@kernel.org, linux-scsi@vger.kernel.org, Suman Tripathi <stripathi@apm.com>, jcm@redhat.com, devicetree-discuss@lists.ozlabs.org, patches@apm.com, Tuan Phan <tphan@apm.com>, linux-arm-kernel@lists.infradead.org

On Fri, Nov 08, 2013 at 03:30:35PM -0700, Loc Ho wrote:
> Signed-off-by: Loc Ho <lho@apm.com>
> Signed-off-by: Tuan Phan <tphan@apm.com>
> Signed-off-by: Suman Tripathi <stripathi@apm.com>
> ---
>  arch/arm64/boot/dts/apm-storm.dtsi |   73 ++++++++++++++++++++++++++++++++++++
>  1 files changed, 73 insertions(+), 0 deletions(-)

Technically this patch doesn't add a binding (the binding is just the
documentation part), it updates the device tree with the SATA devices.

Also, again: Patch description! Not optional.


-Olof
