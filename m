From: Khalid Aziz <khalid.aziz@oracle.com>
Subject: Re: [PATCH 3/3] BusLogic: Use more conventional argument order for
 logging
Date: Fri, 17 May 2013 14:19:42 -0600
Message-ID: <1368821982.24376.3.camel@concerto>
References: <cover.1368754556.git.khalid.aziz@oracle.com>
	 <5fdcd2200869713c58b52d550281da9aa9195efb.1368765873.git.joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5fdcd2200869713c58b52d550281da9aa9195efb.1368765873.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2013-05-16 at 21:58 -0700, Joe Perches wrote:
> Subsystem specific logging messages generally use
> 	subsystem_<level>(struct subsystem *, fmt, ...)
> not
> 	subsystem_<level>(fmt, struct subsystem *, ...)
> 
> Convert to use the more generally used kernel style.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/scsi/BusLogic.c | 304 ++++++++++++++++++++++++------------------------
>  drivers/scsi/BusLogic.h |  24 ++--
>  2 files changed, 161 insertions(+), 167 deletions(-)

Reviewed-by: Khalid Aziz <khalid.aziz@oracle.com>
