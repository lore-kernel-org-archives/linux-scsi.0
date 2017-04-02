From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] tcmu: Skip Data-Out blocks before gathering Data-In
 buffer for BIDI case
Date: Sun, 02 Apr 2017 16:20:17 -0700
Message-ID: <1491175217.8846.60.camel@haakon3.risingtidesystems.com>
References: <1490927725-25131-1-git-send-email-lixiubo@cmss.chinamobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1490927725-25131-1-git-send-email-lixiubo@cmss.chinamobile.com>
Sender: linux-kernel-owner@vger.kernel.org
To: lixiubo@cmss.chinamobile.com
Cc: mchristi@redhat.com, agrover@redhat.com, iliastsi@arrikto.com, namei.unix@gmail.com, sheng@yasker.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2017-03-31 at 10:35 +0800, lixiubo@cmss.chinamobile.com wrote:
> From: Xiubo Li <lixiubo@cmss.chinamobile.com>
> 
> For the bidirectional case, the Data-Out buffer blocks will always at
> the head of the tcmu_cmd's bitmap, and before gathering the Data-In
> buffer, first of all it should skip the Data-Out ones, or the device
> supporting BIDI commands won't work.
> 
> Fixed: 26418649eead ("target/user: Introduce data_bitmap, replace
> 		data_length/data_head/data_tail")
> Reported-by: Ilias Tsitsimpis <iliastsi@arrikto.com>
> Signed-off-by: Xiubo Li <lixiubo@cmss.chinamobile.com>
> ---
>  drivers/target/target_core_user.c | 48 +++++++++++++++++++++++++++------------
>  1 file changed, 33 insertions(+), 15 deletions(-)

Applied to target-pending/master, with a CC' to linux-4.6.y stable.

Thanks Xiubo + Ilias.
