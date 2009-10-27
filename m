From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 4/14] drivers/message: Move dereference after NULL test
Date: Tue, 27 Oct 2009 11:40:48 +0000
Message-ID: <20091027114048.2f79ca46@lxorguk.ukuu.org.uk>
References: <Pine.LNX.4.64.0910170833480.9213@ask.diku.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33502 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753382AbZJ0LjF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Oct 2009 07:39:05 -0400
In-Reply-To: <Pine.LNX.4.64.0910170833480.9213@ask.diku.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Julia Lawall <julia@diku.dk>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-scsi@vger.kernel.org

On Sat, 17 Oct 2009 08:34:18 +0200 (CEST)
Julia Lawall <julia@diku.dk> wrote:

> From: Julia Lawall <julia@diku.dk>
> 
> If the NULL test on dev->i2o_dev or i2o_dev is needed, then the dereference
> should be after the NULL test.
> 
> A simplified version of the semantic match that detects this problem is as
> follows (http://coccinelle.lip6.fr/):

Real bug - actually this needs proper locking but I doubt anyone uses I2O
hardware any. Should go in anyway

> Signed-off-by: Julia Lawall <julia@diku.dk>
Signed-off-by: Alan Cox <alan@linux.intel.com>
