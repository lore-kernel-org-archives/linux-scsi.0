From: Alan Cox <alan@redhat.com>
Subject: Re: [2.6 patch] SCSI atp870u.c: make a needlessly global function static
Date: Mon, 15 Nov 2004 08:38:32 -0500
Message-ID: <20041115133832.GC3964@devserv.devel.redhat.com>
References: <20041115015430.GF2249@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:54472 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S261594AbUKONjr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Nov 2004 08:39:47 -0500
Content-Disposition: inline
In-Reply-To: <20041115015430.GF2249@stusta.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@stusta.de>
Cc: Red Hat <alan@redhat.com>, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Nov 15, 2004 at 02:54:30AM +0100, Adrian Bunk wrote:
> The patch below makes the function is870 which has no external users 
> static.

ACK. Makes total sense
