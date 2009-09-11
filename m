From: Sergey Temerkhanov <temerkhanov@yandex.ru>
Subject: Re: BUG: bnx2i: scheduling while atomic while modprobing bnx2i module
Date: Fri, 11 Sep 2009 18:30:44 +0400
Message-ID: <200909111830.44709.temerkhanov@yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from forward1.yandex.ru ([77.88.46.6]:41404 "EHLO forward1.yandex.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751627AbZIKOnZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Sep 2009 10:43:25 -0400
Received: from smtp2.yandex.ru (smtp2.yandex.ru [77.88.46.102])
	by forward1.yandex.ru (Yandex) with ESMTP id 3F36FAF0049
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2009 18:30:17 +0400 (MSD)
Received: from satanklaus.cifronic.local (cifronik.21th.com [62.16.86.116])
	by smtp2.yandex.ru (Yandex) with ESMTPSA id 1C7A0D18142
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2009 18:30:17 +0400 (MSD)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

This patch is already in 2.6.31 but it has this problem.

On Friday 11 September 2009 16:33:36 Anil Veerabhadrappa wrote:
> This should be resolved by a patch from 3 weeks ago.
>
> reference:
> http://kerneltrap.org/mailarchive/linux-scsi/2009/8/15/6319303
>

Regards, Sergey Temerkhanov
