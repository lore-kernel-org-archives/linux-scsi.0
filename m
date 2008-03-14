From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] scsi: The supplement for the arithmetic of iomem of the
 Type_B Adapter of arcmsr
Date: Fri, 14 Mar 2008 13:03:21 -0700
Message-ID: <20080314130321.29097e8e.akpm@linux-foundation.org>
References: <000201c885d2$1814ecb0$9a00a8c0@Nick>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59637 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758920AbYCNUE6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Mar 2008 16:04:58 -0400
In-Reply-To: <000201c885d2$1814ecb0$9a00a8c0@Nick>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nick.cheng@areca.com.tw
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, randy.dunlap@oracle.com, thenzl@redhat.com, viro@ftp.linux.org.uk

On Fri, 14 Mar 2008 20:51:17 +0800
"nickcheng" <nick.cheng@areca.com.tw> wrote:

> [patch-ChangeLog.arcmsr.txt  text/plain (764B)]
> ___--- ChangeLog.arcmsr.old	2008-03-14 20:15:07.000000000 +0800
> +++ ChangeLog.arcmsr.new	2008-03-14 20:02:12.000000000 +0800
> @@ -115,4 +115,8 @@

This patch had three weird non-ascii characters at the start.

Please prepare patches in `patch -p1' form.  So the patch will apply with
`patch -p1' from within the kernel's top-level directory.

I fixed both the above problems.

Does this file actually need to exist?  We prefer to get our changelog
information from `git-log', not from a standalone file.

