From: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Subject: Re: [PATCH v3 29/32] MAINTAINERS: Add cxlflash driver
Date: Fri, 25 Sep 2015 11:08:19 +1000
Message-ID: <56049E83.8060503@au1.ibm.com>
References: <1443123193-16498-1-git-send-email-mrochs@linux.vnet.ibm.com> <1443123841-17817-1-git-send-email-mrochs@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:38863 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854AbbIYBJB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Sep 2015 21:09:01 -0400
Received: from /spool/local
	by e23smtp05.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <andrew.donnellan@au1.ibm.com>;
	Fri, 25 Sep 2015 11:08:59 +1000
Received: from d23relay06.au.ibm.com (d23relay06.au.ibm.com [9.185.63.219])
	by d23dlp03.au.ibm.com (Postfix) with ESMTP id C6D953578053
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2015 11:08:55 +1000 (EST)
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay06.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t8P18iHX40042536
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2015 11:08:52 +1000
Received: from d23av01.au.ibm.com (localhost [127.0.0.1])
	by d23av01.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t8P18M4W009743
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2015 11:08:23 +1000
In-Reply-To: <1443123841-17817-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Tomas Henzl <thenzl@redhat.com>, David Laight <David.Laight@ACULAB.COM>
Cc: Michael Neuling <mikey@neuling.org>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org

On 25/09/15 05:44, Matthew R. Ochs wrote:
> Add stanza for cxlflash SCSI driver.
>
> Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
> Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
> Reviewed-by: Brian King <brking@linux.vnet.ibm.com>

Reviewed-by: Andrew Donnellan <andrew.donnellan@au1.ibm.com>

> ---
>   MAINTAINERS | 9 +++++++++
>   1 file changed, 9 insertions(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 274f854..f2f3046 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3153,6 +3153,15 @@ F:	Documentation/powerpc/cxl.txt
>   F:	Documentation/powerpc/cxl.txt
>   F:	Documentation/ABI/testing/sysfs-class-cxl
>
> +CXLFLASH (IBM Coherent Accelerator Processor Interface CAPI Flash) SCSI DRIVER
> +M:	Manoj N. Kumar <manoj@linux.vnet.ibm.com>
> +M:	Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
> +L:	linux-scsi@vger.kernel.org
> +S:	Supported
> +F:	drivers/scsi/cxlflash/
> +F:	include/uapi/scsi/cxlflash_ioctls.h
> +F:	Documentation/powerpc/cxlflash.txt
> +
>   STMMAC ETHERNET DRIVER
>   M:	Giuseppe Cavallaro <peppe.cavallaro@st.com>
>   L:	netdev@vger.kernel.org
>

-- 
Andrew Donnellan              Software Engineer, OzLabs
andrew.donnellan@au1.ibm.com  Australia Development Lab, Canberra
+61 2 6201 8874 (work)        IBM Australia Limited

