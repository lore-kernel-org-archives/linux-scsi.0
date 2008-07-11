From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Fix error handling in i2o_device_add()
Date: Fri, 11 Jul 2008 12:17:17 -0700
Message-ID: <20080711121717.874b3ff9.akpm@linux-foundation.org>
References: <20080710120501.27638.83131.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50656 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759094AbYGKTSc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jul 2008 15:18:32 -0400
In-Reply-To: <20080710120501.27638.83131.stgit@warthog.procyon.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: alan@redhat.com, Markus.Lidel@shadowconnect.com, vvs@sw.ru, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Wang Chen <wangchen@cn.fujitsu.com>

On Thu, 10 Jul 2008 13:05:02 +0100 David Howells <dhowells@redhat.com> wrote:

> Fix error handling in i2o_device_add() - sysfs_create_link() can return an
> error.

Please review -mm's i2o-handle-sysfs_create_link-failures.patch and see if
I should fix or replace that patch.

