From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] iscsi-target: Use kmemdup rather than duplicating its
 implementation
Date: Sun, 27 Nov 2011 22:38:45 -0800
Message-ID: <1322462325.20311.465.camel@haakon2.linux-iscsi.org>
References: <1321569820.1624.298.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:38591 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755Ab1K1Gis (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Nov 2011 01:38:48 -0500
In-Reply-To: <1321569820.1624.298.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Thomas Meyer <thomas@m3y3r.de>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, 2011-11-17 at 23:43 +0100, Thomas Meyer wrote:
> The semantic patch that makes this change is available
> in scripts/coccinelle/api/memdup.cocci.
> 
> Signed-off-by: Thomas Meyer <thomas@m3y3r.de>

Hi Thomas,

My apologies for the delayed response.  This patch has been applied to
lio-core.git, and will be included for the v3.3 merge.

Thanks!

--nab

