From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: Re: [PATCH 33/41] scsi: osd: osd_initiator: mark expected switch
 fall-throughs
Date: Wed, 19 Dec 2018 18:07:28 -0600
Message-ID: <ad100db6-ea99-e537-333b-8018ae6a05f8@embeddedor.com>
References: <cover.1543374820.git.gustavo@embeddedor.com>
 <09026c2661bf3c4bcf41dbb265cf1dae2c3487fd.1543374820.git.gustavo@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <09026c2661bf3c4bcf41dbb265cf1dae2c3487fd.1543374820.git.gustavo@embeddedor.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Boaz Harrosh <ooo@electrozaur.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi,

Friendly ping:

Who can ack or review this patch, please?

Thanks
--
Gustavo

On 11/27/18 10:32 PM, Gustavo A. R. Silva wrote:
> In preparation to enabling -Wimplicit-fallthrough, mark switch cases
> where we are expecting to fall through.
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
>   drivers/scsi/osd/osd_initiator.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
> index 60cf7c5eb880..cb26f26d5ec1 100644
> --- a/drivers/scsi/osd/osd_initiator.c
> +++ b/drivers/scsi/osd/osd_initiator.c
> @@ -1849,6 +1849,7 @@ int osd_req_decode_sense_full(struct osd_request *or,
>   					32, 1, dump, sizeof(dump), true);
>   			OSD_SENSE_PRINT2("response_integrity [%s]\n", dump);
>   		}
> +		/* fall through */
>   		case osd_sense_attribute_identification:
>   		{
>   			struct osd_sense_attributes_data_descriptor
> @@ -1879,7 +1880,7 @@ int osd_req_decode_sense_full(struct osd_request *or,
>   					attr_page, attr_id);
>   			}
>   		}
> -		/*These are not legal for OSD*/
> +		/* fall through - These are not legal for OSD */
>   		case scsi_sense_field_replaceable_unit:
>   			OSD_SENSE_PRINT2("scsi_sense_field_replaceable_unit\n");
>   			break;
> 
