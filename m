From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH][SCSI] hptiop: Support HighPoint RR4520/RR4522 HBA
Date: Wed, 24 Oct 2012 12:25:55 -0700
Message-ID: <20121024122555.40ffad99.akpm@linux-foundation.org>
References: <50876076.2040106@highpoint-tech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41123 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933046Ab2JXTZ4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Oct 2012 15:25:56 -0400
In-Reply-To: <50876076.2040106@highpoint-tech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: HighPoint Linux Team <linux@highpoint-tech.com>
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org

On Wed, 24 Oct 2012 11:28:54 +0800
HighPoint Linux Team <linux@highpoint-tech.com> wrote:

> Support HighPoint RR4520/RR4522 HBAs which are based on Marvell Frey.
> 
> Signed-off-by: HighPoint Linux Team <linux@highpoint-tech.com>
> 
>   Documentation/scsi/hptiop.txt |   69 ++++++-
>   drivers/scsi/hptiop.c         |  413 
> ++++++++++++++++++++++++++++++++++++++++--
>   drivers/scsi/hptiop.h         |   72 +++++++
>   3 files changed, 530 insertions(+), 24 deletions(-)

The patch is terribly wordwrapped and has its tabs replaced with
spaces.  I sugegst you resend it as a text/plain email attachment,
please.

