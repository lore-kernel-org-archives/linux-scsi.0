From: Christoph Hellwig <hch@infradead.org>
Subject: Re: read capacity 16
Date: Thu, 9 Dec 2004 15:02:09 +0000
Message-ID: <20041209150209.GA16698@infradead.org>
References: <47F3C2BE74738E4683574107469DFA206783D7@XYUSEX01.xyus.xyratex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.146.154.40] ([213.146.154.40]:25002 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261488AbULIPCK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Dec 2004 10:02:10 -0500
Content-Disposition: inline
In-Reply-To: <47F3C2BE74738E4683574107469DFA206783D7@XYUSEX01.xyus.xyratex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Frank Borich <Frank_Borich@us.xyratex.com>
Cc: linux-scsi@vger.kernel.org

On Thu, Dec 09, 2004 at 06:33:15AM -0800, Frank Borich wrote:
> This works as expected using SGI's 2.6.5-rc3-mm4 on ia64 and on Windows
> server 2003 SP1 (still a beta).
> Does anyone know how to get kernels > than 2.4.19 to work ?
> 
> I tried setting max_cmd_len to 16 in hosts.c, but it doesn't change
> anything.

The 2.4 scsi layer doesn't issue 16 byte commands at all. 

