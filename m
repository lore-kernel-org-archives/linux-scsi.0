From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH -next] target/sbc: Fix sparse non static symbol warning
Date: Fri, 10 Jan 2014 11:43:02 -0800
Message-ID: <1389382982.5567.423.camel@haakon3.risingtidesystems.com>
References: <CAPgLHd_yj=Te74XPRaKit5SdHerr2ywPgAMArETZ3YE3CCL=tQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:52496 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbaAJTlR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Jan 2014 14:41:17 -0500
In-Reply-To: <CAPgLHd_yj=Te74XPRaKit5SdHerr2ywPgAMArETZ3YE3CCL=tQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: yongjun_wei@trendmicro.com.cn, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

Hi Wei,

On Fri, 2014-01-10 at 23:39 +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Fixes the following sparse warning:
> 
> drivers/target/target_core_sbc.c:573:1: warning:
>  symbol 'sbc_check_prot' was not declared. Should it be static?
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---

Fengguang beat you to this one.  ;)

Regardless, thanks for the heads up.

--nab

