From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] libata: slightly improved req-sense, send-diag no-ops
Date: Fri, 21 Sep 2007 12:17:17 +0100
Message-ID: <20070921121717.16c7dcf1@the-village.bc.nu>
References: <20070921102424.GA17675@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20070921102424.GA17675@havoc.gtf.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>     REQUEST SENSE -- as we autosense, R.S. just returns zeroes
>     
>     SEND DIAGNOSTIC -- our default (no-op) self-test succeeds, all
>     		   other requests for testing fail.
>     
>     Signed-off-by: Jeff Garzik <jeff@garzik.org>

Acked-by: Alan Cox <alan@redhat.com>

Possibly our default SEND_DIAGNOSTIC should turn into smart or just
return whether the drive failed the power up diagnostic ?
