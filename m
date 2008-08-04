From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 9/10] drivers/scsi/megaraid: Use DIV_ROUND_UP
Date: Mon, 4 Aug 2008 14:09:32 +0100
Message-ID: <20080804140932.0167ac82@lxorguk.ukuu.org.uk>
References: <Pine.LNX.4.64.0808021715270.20095@ask.diku.dk>
	<4B6A08C587958942AA3002690DD4F8C31B0FCFA2@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60723 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753448AbYHDN05 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Aug 2008 09:26:57 -0400
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C31B0FCFA2@cosmail02.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>
Cc: Julia Lawall <julia@diku.dk>, DL-MegaRAID Linux <megaraidlinux@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>, "Austria, Winston" <Winston.Austria@lsi.com>, "Yuen, Eric" <Eric.Yuen@lsi.com>

On Mon, 4 Aug 2008 06:40:27 -0600
"Yang, Bo" <Bo.Yang@lsi.com> wrote:

> Julia,
> 
> Frame_count is the major parameter used by our megaraid sas FW.  It may cause some issues after this change.  Please keep the original implementation.

The two are identical code - please explain
