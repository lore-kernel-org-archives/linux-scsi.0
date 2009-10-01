From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Add hpsa driver for HP Smart Array controllers.
Date: Thu, 1 Oct 2009 14:30:35 -0700
Message-ID: <20091001143035.a83a7564.akpm@linux-foundation.org>
References: <20091001211705.15591.76403.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753151AbZJAVbQ@vger.kernel.org>
In-Reply-To: <20091001211705.15591.76403.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, axboe@kernel.dk, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, mikem@beardog.cce.hp.com, scameron@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

On Thu, 01 Oct 2009 16:25:30 -0500
"Stephen M. Cameron" <scameron@beardog.cce.hp.com> wrote:

> Add hpsa driver for HP Smart Array controllers.
> 
> This driver supports a subset of HP Smart Array Controllers.
> It is a SCSI alternative to the cciss driver.

Does it support all the devices which cciss supports?

IOW, do we have a plan here to remove the cciss driver or must we
maintain both drivers indefinitely?
