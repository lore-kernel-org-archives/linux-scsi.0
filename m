From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [scsi] WARNING: at fs/sysfs/dir.c:530 sysfs_add_one()
Date: Wed, 12 Jun 2013 19:34:43 -0700
Message-ID: <1371090883.1978.61.camel@dabdike>
References: <20130613013032.GA7558@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130613013032.GA7558@localhost>
Sender: linux-kernel-owner@vger.kernel.org
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2013-06-13 at 09:30 +0800, Fengguang Wu wrote:
> Greetings,
> 
> I got the below dmesg and the first bad commit is
> 
> commit a256ba092ec57213f96059d41ac5473ff92f5e7c
> Author: Nicholas Bellinger <nab@linux-iscsi.org>
> Date:   Sat May 18 02:40:43 2013 -0700
> 
>     scsi: Split scsi_dispatch_cmd into __scsi_dispatch_cmd setup
>     
>     Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>

You may be evaluating a bogus branch because no such commit has darkened
the SCSI list, so it obviously can't be on upstream track.

James
