From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 0/3] ibmvscsis driver rewrite
Date: Thu, 10 Feb 2011 10:34:44 -0800
Message-ID: <1297362884.18212.146.camel@haakon2.linux-iscsi.org>
References: <1297340495-13347-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:51989 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137Ab1BJSeu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Feb 2011 13:34:50 -0500
In-Reply-To: <1297340495-13347-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org

On Thu, 2011-02-10 at 21:21 +0900, FUJITA Tomonori wrote:
> Finally, I have the working driver. We are ready to remove the old
> ibmvstgt driver.
> 
> This is for scsi-misc tree.
> 
> =
>  drivers/scsi/ibmvscsi/Makefile    |    4 +-
>  drivers/scsi/ibmvscsi/ibmvscsis.c | 1759 +++++++++++++++++++++++++++++++++++++
>  drivers/scsi/libsrp.c             |   18 +-
>  include/scsi/libsrp.h             |   10 +-
>  4 files changed, 1778 insertions(+), 13 deletions(-)
> 

Many thanks for this updated patch series Tomo-san.

I will add this series to a working lio-core-2.6.git/tcm_ibmvscsis
branch from the current LIO upstream HEAD (linus-38-rc4).  I will review
shortly and add my comments..

Also, would you mind sending along 'tree', 'dmesg' and 'lsmod' output of
a functional ibmvscsis system so we can add a proper LIO wiki
entry..?  :-)

--nab

