From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] iscsi-target: return -ENOMEM instead of -1 in case of
 failed kmalloc()
Date: Sat, 14 Nov 2015 14:31:13 -0800
Message-ID: <1447540273.18527.5.camel@haakon3.risingtidesystems.com>
References: <1445285904-31247-1-git-send-email-luisbg@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1445285904-31247-1-git-send-email-luisbg@osg.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Luis de Bethencourt <luisbg@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org, cvubrugier@fastmail.fm, sagig@mellanox.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Luis,

Apologies for the delayed response.

On Mon, 2015-10-19 at 21:18 +0100, Luis de Bethencourt wrote:
> Smatch complains about returning hard coded error codes, silence this
> warning.
> 
> drivers/target/iscsi/iscsi_target_parameters.c:211 iscsi_create_default_params() warn: returning -1 instead of -ENOMEM is sloppy
> 
> Signed-off-by: Luis de Bethencourt <luisbg@osg.samsung.com>
> ---
> 
> Hi,
> 
> This doesn't change the functionality. It is just about using the more specific
> errno. And at the same time silencing smatch.
> 
> Thanks,
> Luis
> 
>  drivers/target/iscsi/iscsi_target_parameters.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 

Applied to target-pending/queue-fixes.

Thank you,

--nab
