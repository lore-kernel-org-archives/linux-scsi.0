From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: Re: [PATCH 36/41] scsi: qla4xxx: ql4_os: mark expected switch
 fall-through
Date: Wed, 19 Dec 2018 18:07:56 -0600
Message-ID: <d1b5f382-cdf6-8cba-c5a7-f695c65b7cd7@embeddedor.com>
References: <cover.1543374820.git.gustavo@embeddedor.com>
 <a118ae0eeeb3cdcd4846bc1031ea89ca62af1e00.1543374820.git.gustavo@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <a118ae0eeeb3cdcd4846bc1031ea89ca62af1e00.1543374820.git.gustavo@embeddedor.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: QLogic-Storage-Upstream@qlogic.com
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi,

Friendly ping:

Who can ack or review this patch, please?

Thanks
--
Gustavo

On 11/27/18 10:33 PM, Gustavo A. R. Silva wrote:
> In preparation to enabling -Wimplicit-fallthrough, mark switch cases
> where we are expecting to fall through.
> 
> Notice that, in this particular case, I replaced "allow fall-through"
> with a "fall through" annotation, which is what GCC is expecting to
> find.
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
>   drivers/scsi/qla4xxx/ql4_os.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
> index 1c702cd22359..7fd3491ea2d9 100644
> --- a/drivers/scsi/qla4xxx/ql4_os.c
> +++ b/drivers/scsi/qla4xxx/ql4_os.c
> @@ -2876,7 +2876,7 @@ static int qla4xxx_session_get_param(struct iscsi_cls_session *cls_sess,
>   						chap_tbl.secret_len);
>   			}
>   		}
> -		/* allow fall-through */
> +		/* fall through */
>   	default:
>   		return iscsi_session_get_param(cls_sess, param, buf);
>   	}
> 
