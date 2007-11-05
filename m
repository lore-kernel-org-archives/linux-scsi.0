From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [2.6 patch] scsi/aic94xx/: cleanups
Date: Mon, 5 Nov 2007 11:43:35 -0800
Message-ID: <20071105194334.GA7010@tree.beaverton.ibm.com>
References: <20071105170729.GO12045@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:36998 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbXKETns (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Nov 2007 14:43:48 -0500
Content-Disposition: inline
In-Reply-To: <20071105170729.GO12045@stusta.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@kernel.org>
Cc: James.Bottomley@SteelEye.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, Nov 05, 2007 at 06:07:29PM +0100, Adrian Bunk wrote:
> This patch contains the following cleanups:
> - static functions in .c files shouldn't be marked inline
> - make needlessly global code static
> - #if 0 unused code

asd_unpause_lseq can be removed; the other if 0'd functions are debug
functions and can probably stay.

Otherwise, ack.

--D
