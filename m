From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 2/5] drivers/scsi/aic94xx/: replace __FUNCTION__ with
	__func__
Date: Fri, 25 Jul 2008 09:42:54 -0700
Message-ID: <20080725164253.GA7355@tree.beaverton.ibm.com>
References: <1216954114-31949-1-git-send-email-crquan@gmail.com>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:42265 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbYGYQnO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Jul 2008 12:43:14 -0400
Content-Disposition: inline
In-Reply-To: <1216954114-31949-1-git-send-email-crquan@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Denis ChengRq <crquan@gmail.com>
Cc: linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, Jul 25, 2008 at 10:48:33AM +0800, Denis ChengRq wrote:
> Signed-off-by: Denis ChengRq <crquan@gmail.com>

No justification or changelog?

> -		__FUNCTION__)
> +		__func__)

include/linux/kernel.h:503:#define __FUNCTION__ (__func__)

I assume you're trying to kill this?

--D
