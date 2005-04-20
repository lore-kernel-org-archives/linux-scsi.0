From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: Re: [PATCH]megaraid_sas: Reduce stack usage in megasas_probe_one()
Date: Wed, 20 Apr 2005 09:26:57 -0700
Message-ID: <20050420092657.10bce1f7.rddunlap@osdl.org>
References: <df35dfeb0504200059279a4417@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fire.osdl.org ([65.172.181.4]:40621 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S261712AbVDTQ1J (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Apr 2005 12:27:09 -0400
In-Reply-To: <df35dfeb0504200059279a4417@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Yum Rayan <yum.rayan@gmail.com>
Cc: Sreenivas.Bagalkote@lsil.com, linux-scsi@vger.kernel.org

On Wed, 20 Apr 2005 00:59:43 -0700 Yum Rayan wrote:

| This patch reduces stack usage in megasas_probe_one() from to 2200 to
| 156. A patched version of gcc 3.4.3 with -fno-unit-at-a-time disabled
| was used on i386 platform.

Hi Yum,

In the future, please use "diff -up" (or even more options,
but please add the 'p') so that we can easily see what functions
or structs the modifications are in.

Check Documentation/SubmittingPatches:

1) "diff -up"
------------
Use "diff -up" or "diff -uprN" to create patches.


diffstat output would also be a good addition.

Thanks,
---
~Randy
