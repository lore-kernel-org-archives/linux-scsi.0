From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] aacraid: add cpu cache flush after kmapping and modifying
 a page
Date: Thu, 21 Jun 2007 14:41:13 +0900
Message-ID: <467A0F79.40909@gmail.com>
References: <AE4F746F2AECFC4DA4AADD66A1DFEF01B22F4C@otce2k301.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.233]:22686 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbXFUFlT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Jun 2007 01:41:19 -0400
Received: by nz-out-0506.google.com with SMTP id n1so485365nzf
        for <linux-scsi@vger.kernel.org>; Wed, 20 Jun 2007 22:41:18 -0700 (PDT)
In-Reply-To: <AE4F746F2AECFC4DA4AADD66A1DFEF01B22F4C@otce2k301.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@SteelEye.com>

Salyzyn, Mark wrote:
> Updated patch to address overlap with patches introduced by FUJITA
> Tomonori <fujita.tomonori@lab.ntt.co.jp>. Tejun, please inspect.

I'm sorry but this patch is really out of my hand.  James?

-- 
tejun
