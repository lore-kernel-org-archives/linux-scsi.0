From: Rob Landley <landley@trommello.org>
Subject: Re: [patch] show Fusion MPT dialog only when CONFIG_BLK_DEV_SD is set
Date: Wed, 9 Oct 2002 15:55:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021010005608.6CA55622@merlin.webofficenow.com>
References: <Pine.NEB.4.44.0210091354300.8340-100000@mimas.fachschaften.tu-muenchen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <Pine.NEB.4.44.0210091354300.8340-100000@mimas.fachschaften.tu-muenchen.de>
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@fs.tum.de>, linux-scsi@vger.kernel.org
Cc: Matt Porter <porter@cox.net>, linux-kernel@vger.kernel.org

On Wednesday 09 October 2002 08:15 am, Adrian Bunk wrote:

> Thinking about it the following is perhaps a better solution since the
> fix is now in the arch-independent part.

That's good too, but it still belongs in the scsi low-level driver menu
since it's a scsi low level driver.  (I just sent a much less ambitius 
patch...)

Rob
