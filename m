From: Xi Wang <xi.wang@gmail.com>
Subject: Re: [PATCH] iscsi_tcp: bound max_r2t in iscsi_sw_tcp_conn_set_param()
Date: Wed, 4 Jan 2012 02:12:42 -0500
Message-ID: <402ECD7E-78CA-4375-B978-E180173195E4@gmail.com>
References: <1325368867-13696-1-git-send-email-xi.wang@gmail.com> <4F015753.1010106@cs.wisc.edu> <2EB25344-4C9E-4D3C-8406-5A4D015CB364@gmail.com> <260F336C-1C68-4DDE-9FFB-094F7AEFB3C8@gmail.com> <4F03FCE9.1090603@cs.wisc.edu>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:49050 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752394Ab2ADHMr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Jan 2012 02:12:47 -0500
In-Reply-To: <4F03FCE9.1090603@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org, stable@vger.kernel.org

On Jan 4, 2012, at 2:16 AM, Mike Christie wrote:
> I thought short was 32767 and ushort was 65535. Is a short like long
> where it is different on different archs?

it is 65535, but the patch has an extra check is_power_of_2(), right?

- xi
