From: Xi Wang <xi.wang@gmail.com>
Subject: Re: [PATCH] iscsi_tcp: bound max_r2t in iscsi_sw_tcp_conn_set_param()
Date: Mon, 2 Jan 2012 09:18:07 -0500
Message-ID: <2EB25344-4C9E-4D3C-8406-5A4D015CB364@gmail.com>
References: <1325368867-13696-1-git-send-email-xi.wang@gmail.com> <4F015753.1010106@cs.wisc.edu>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56186 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196Ab2ABOSM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Jan 2012 09:18:12 -0500
In-Reply-To: <4F015753.1010106@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org, stable@vger.kernel.org

On Jan 2, 2012, at 2:05 AM, Mike Christie wrote:
> Are you actually hitting this and if so with what tools and target? And
> when using greater than 1 do you see any throughput improvements?

No, I was worrying about security.

> What about the attached patch? It also fixes cxgb*i.
> <0001-libiscsi_tcp-fix-max_r2t-manipulation.patch>

Looks good to me.  Thanks!

- xi
