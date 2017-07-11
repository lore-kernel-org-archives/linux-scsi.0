From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] tcmu: clean up the code and with one small fix
Date: Tue, 11 Jul 2017 10:49:33 -0700
Message-ID: <1499795373.19338.1.camel@haakon3.daterainc.com>
References: <1499767601-18328-1-git-send-email-lixiubo@cmss.chinamobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1499767601-18328-1-git-send-email-lixiubo@cmss.chinamobile.com>
Sender: target-devel-owner@vger.kernel.org
To: lixiubo@cmss.chinamobile.com
Cc: mchristi@redhat.com, bryantly@linux.vnet.ibm.com, damien.lemoal@wdc.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2017-07-11 at 18:06 +0800, lixiubo@cmss.chinamobile.com wrote:
> From: Xiubo Li <lixiubo@cmss.chinamobile.com>
> 
> Remove useless blank line and code and at the same time add one error
> path to catch the errors.
> 
> Signed-off-by: Xiubo Li <lixiubo@cmss.chinamobile.com>
> ---
>  drivers/target/target_core_user.c | 24 +++++++++++-------------
>  1 file changed, 11 insertions(+), 13 deletions(-)

Applied.

Thanks Xiubo.
