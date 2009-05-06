From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 5/10] scsi: megaraid_sas - Fixed load/unload issue and
 Fire the system pd DCDB cmd to MegaRAID SAS FW to get the system PDs
Date: Wed, 6 May 2009 14:20:57 -0700
Message-ID: <20090506142057.8a2c51ab.akpm@linux-foundation.org>
References: <4B6A08C587958942AA3002690DD4F8C354F61C50@cosmail02.lsi.com>
	<4B6A08C587958942AA3002690DD4F8C354F61C55@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52691 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760886AbZEFVYF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 May 2009 17:24:05 -0400
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C354F61C55@cosmail02.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: Bo.Yang@lsi.com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Winston.Austria@lsi.com

On Tue, 5 May 2009 19:24:07 -0600
"Yang, Bo" <Bo.Yang@lsi.com> wrote:

> +} __attribute__ ((packed));

Please use __packed.  I'd suggest this be done as a single driver-wide cleanup
patch at a convenient time.
