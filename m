From: Alan Cox <alan@redhat.com>
Subject: Re: [2.6 patch] drivers/scsi/atp870u.c: make a function static
Date: Sat, 23 Apr 2005 20:14:30 -0400
Message-ID: <20050424001430.GB1236@devserv.devel.redhat.com>
References: <20050423220817.GF4355@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:18904 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S262195AbVDXAPd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 23 Apr 2005 20:15:33 -0400
Content-Disposition: inline
In-Reply-To: <20050423220817.GF4355@stusta.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@stusta.de>
Cc: alan@redhat.com, linux-kernel@vger.kernel.org, James.Bottomley@SteelEye.co, linux-scsi@vger.kernel.org

On Sun, Apr 24, 2005 at 12:08:18AM +0200, Adrian Bunk wrote:
> This patch makes a needlessly global function static.

ACK

> 
