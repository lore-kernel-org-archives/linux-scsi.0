From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] sd.c fixes applied incorectly to 2.4.19-preXX
Date: Tue, 16 Apr 2002 07:58:20 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020416055820.GF12608@suse.de>
References: <200204152040.g3FKed982111@aslan.scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200204152040.g3FKed982111@aslan.scsiguy.com>
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: Marcelo Tosatti <marcelo@conectiva.com.br>, linux-scsi@vger.kernel.org, Alan Cox <alan@redhat.com>

On Mon, Apr 15 2002, Justin T. Gibbs wrote:
> Marcelo,
> 
> Looking at the latest version of your tree via bitkeeper, it
> seems that the wrong patch has been applied to sd.c.  In its
> current state, the disk driver will fail to act upon any sense
> data returned by the low level controller.  The following patch
> restores correct behavior.

Justin,

Noticed this myself the other day... I don't think they were applied
incorrectly, your 2.4.18 patch is buggy while your 2.4.17 version is
quite ok.

-- 
Jens Axboe

