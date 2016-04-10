From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [PATCH v2 07/16] iscsi-target: add int
 (*iscsit_validate_params)()
Date: Sun, 10 Apr 2016 20:50:23 +0300
Message-ID: <570A925F.6080003@grimberg.me>
References: <cover.1460204441.git.varun@chelsio.com>
 <1b7a0271cf70d869a26fc042ab2b123afeb1c8ad.1460204441.git.varun@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33086 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754816AbcDJRu1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 10 Apr 2016 13:50:27 -0400
In-Reply-To: <1b7a0271cf70d869a26fc042ab2b123afeb1c8ad.1460204441.git.varun@chelsio.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Varun Prakash <varun@chelsio.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: nab@linux-iscsi.org, swise@opengridcomputing.com, kxie@chelsio.com, indranil@chelsio.com


> Add int (*iscsit_validate_params)() to
> struct iscsit_transport, iscsi-target
> uses this callback for validating
> conn operational parameters.

Again, why is this needed?
