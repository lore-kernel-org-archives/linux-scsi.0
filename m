From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [RFC 22/34] iscsi-target: call Rx thread function
Date: Mon, 15 Feb 2016 19:16:51 +0200
Message-ID: <56C20803.6030908@dev.mellanox.co.il>
References: <cover.1455467089.git.varun@chelsio.com>
 <19973d4150937cdaffec583caa35b5d8c9a64fbb.1455467089.git.varun@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:36222 "EHLO
	mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174AbcBORQz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Feb 2016 12:16:55 -0500
Received: by mail-wm0-f54.google.com with SMTP id g62so69009489wme.1
        for <linux-scsi@vger.kernel.org>; Mon, 15 Feb 2016 09:16:54 -0800 (PST)
In-Reply-To: <19973d4150937cdaffec583caa35b5d8c9a64fbb.1455467089.git.varun@chelsio.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Varun Prakash <varun@chelsio.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: nab@linux-iscsi.org, roland@kernel.org, swise@opengridcomputing.com, indranil@chelsio.com, kxie@chelsio.com, hariprasad@chelsio.com


> call Rx thread function if registered
> by transport driver, so that transport
> drivers can use iscsi-target Rx thread
> for Rx processing.
>
> update iSER target driver to use this
> interface.
>
> Signed-off-by: Varun Prakash <varun@chelsio.com>

Other than the handler name, looks harmless.

Acked-by: Sagi Grimberg <sagig@mellanox.com>
