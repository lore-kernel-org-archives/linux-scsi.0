From: Olaf Hering <olaf@aepfle.de>
Subject: Re: [PATCH 1/1] Drivers: scsi: storvsc: Get rid of warning messages
Date: Thu, 18 Sep 2014 18:20:04 +0200
Message-ID: <20140918162004.GA18124@aepfle.de>
References: <1409701396-20226-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1409701396-20226-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "K. Y. Srinivasan" <kys@microsoft.com>, hch@infradead.org
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Sep 02, K. Y. Srinivasan wrote:

> Get rid of the warning messages since they will clutter up various system logs
> and are of questionable value to the end user. For debugging purposes, this
> information can be gotten by setting the scsi log level appropriately.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>

Reviewed-by: Olaf Hering <olaf@aepfle.de>
