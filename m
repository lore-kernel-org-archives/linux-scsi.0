From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH v2 3/3] tcm ibmvscsis driver
Date: Mon, 14 Feb 2011 01:12:54 -0800
Message-ID: <1297674774.7114.52.camel@haakon2.linux-iscsi.org>
References: <20110214124821T.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:51483 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051Ab1BNJTZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Feb 2011 04:19:25 -0500
In-Reply-To: <20110214124821T.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@ozlabs.org, brking@linux.vnet.ibm.com

On Mon, 2011-02-14 at 12:48 +0900, FUJITA Tomonori wrote:
> This is the second version of tcm ibmvscsis driver. You can find the
> first version at:
> 
> http://marc.info/?t=129734085600004&r=1&w=2
> 
> The changes are:
> 
> - send VIOSRP_MAD_NOT_SUPPORTED for unknown mad type requests.
> - fix inquiry typo
> - sends task management response (for now, 'NOT SUPPORTED').
> - remove dead code.
> 

Your rev2 patch has been merged into lio-core-2.6.git/tcm_ibmvscsis
currently @ .38-rc4.

Thanks!

--nab




