From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [2.6 patch] SCSI: misc possible cleanups
Date: 14 Nov 2004 22:50:46 -0600
Message-ID: <1100494253.24811.9.camel@mulgrave>
References: <20041115020432.GK2249@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S261444AbUKOEv7@vger.kernel.org>
In-Reply-To: <20041115020432.GK2249@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Adrian Bunk <bunk@stusta.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, 2004-11-14 at 20:04, Adrian Bunk wrote:
> This patch below does:
> - remove unused code

Erm, some of the code you're trying to remove was recently added as
enablers for fibre channel drivers, like this:

[...]

>  drivers/scsi/scsi_transport_fc.c  |  202 ------------------------------

It's really not safe to remove code without understanding why it's there
in the first place.

James
