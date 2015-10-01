From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/3] cxlflash: drop unlikely before IS_ERR_OR_NULL
Date: Thu, 1 Oct 2015 09:49:15 -0500
Message-ID: <5A9BCFAB-6A71-49E4-A845-5B50481DA7B0@linux.vnet.ibm.com>
References: <03d18502ed7ed417f136c091f417d2d88c147ec6.1443667610.git.geliangtang@163.com> <03d18502ed7ed417f136c091f417d2d88c147ec6.1443667610.git.geliangtang@163.com> <081982d1188978b6020952afb4c2dcf3bc42fa1f.1443667610.git.geliangtang@163.com> <7685ffa3f47126617d740292cf35bf92cda193c3.1443667610.git.geliangtang@163.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2102\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:44271 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052AbbJAOt0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Oct 2015 10:49:26 -0400
Received: from localhost
	by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Thu, 1 Oct 2015 08:49:26 -0600
In-Reply-To: <7685ffa3f47126617d740292cf35bf92cda193c3.1443667610.git.geliangtang@163.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Geliang Tang <geliangtang@163.com>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, Michael Neuling <mikey@neuling.org>, Wen Xiong <wenxiong@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Acked-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>

