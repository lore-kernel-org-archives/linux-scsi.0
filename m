From: "Love, Robert W" <robert.w.love@intel.com>
Subject: Re: [PATCH] [SCSI] libfcoe: use list_move instead of
 list_del/list_add
Date: Thu, 6 Sep 2012 15:45:12 +0000
Message-ID: <5048C4EC.6010403@intel.com>
References: <CAPgLHd_m2J1W8Su4NJuShHTzwdb94t=-8=oFv6=r1OL5735uyQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:10353 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757905Ab2IFPpP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Sep 2012 11:45:15 -0400
In-Reply-To: <CAPgLHd_m2J1W8Su4NJuShHTzwdb94t=-8=oFv6=r1OL5735uyQ@mail.gmail.com>
Content-Language: en-US
Content-ID: <FDE09C0604814E4BA3235EEB086DEA72@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: "JBottomley@parallels.com" <JBottomley@parallels.com>, "yongjun_wei@trendmicro.com.cn" <yongjun_wei@trendmicro.com.cn>, "devel@open-fcoe.org" <devel@open-fcoe.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 9/5/2012 9:36 PM, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> Using list_move() instead of list_del() + list_add().
>
> spatch with a semantic match is used to found this problem.
> (http://coccinelle.lip6.fr/)
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Acked-by: Robert Love <robert.w.love@intel.com>

