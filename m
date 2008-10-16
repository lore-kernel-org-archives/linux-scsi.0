From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: qla2xxx: NULL pointer dereference in 2.6.26.6 on module load
Date: Thu, 16 Oct 2008 08:49:43 -0700
Message-ID: <20081016154943.GF55003@plap4-2.local>
References: <87prm0ziz7.fsf@tac.ki.iif.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:21462 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753806AbYJPPto (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Oct 2008 11:49:44 -0400
Content-Disposition: inline
In-Reply-To: <87prm0ziz7.fsf@tac.ki.iif.hu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ferenc Wagner <wferi@niif.hu>
Cc: linux-scsi@vger.kernel.org

On Thu, 16 Oct 2008, Ferenc Wagner wrote:

> This problem is not present in 2.6.18 nor 2.6.27, but I'd like to see
> it fixed in the kernel of Debian Lenny, so came here with a couple of
> questions.

You'll want to backport the following commit to your 2.6.26.6 kernel:

[SCSI] qla2xxx: Skip FDMI registration on ISP21xx/22xx parts.
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=031e134e5f95233d80fb1b62fdaf5e1be587597c
