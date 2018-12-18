From: Boaz Harrosh <ooo@electrozaur.com>
Subject: Re: [PATCH 33/41] scsi: osd: osd_initiator: mark expected switch
 fall-throughs
Date: Tue, 18 Dec 2018 19:13:45 +0200
Message-ID: <ee906c63-72cd-8d3c-d5c8-50dc59d984d8@electrozaur.com>
References: <cover.1543374820.git.gustavo@embeddedor.com>
 <09026c2661bf3c4bcf41dbb265cf1dae2c3487fd.1543374820.git.gustavo@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <09026c2661bf3c4bcf41dbb265cf1dae2c3487fd.1543374820.git.gustavo@embeddedor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 28/11/18 06:32, Gustavo A. R. Silva wrote:
> In preparation to enabling -Wimplicit-fallthrough, mark switch cases
> where we are expecting to fall through.
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

ACK-by: Boaz Harrosh <ooo@electrozaur.com>

> ---
>  drivers/scsi/osd/osd_initiator.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
> index 60cf7c5eb880..cb26f26d5ec1 100644
> --- a/drivers/scsi/osd/osd_initiator.c
> +++ b/drivers/scsi/osd/osd_initiator.c
> @@ -1849,6 +1849,7 @@ int osd_req_decode_sense_full(struct osd_request *or,
>  					32, 1, dump, sizeof(dump), true);
>  			OSD_SENSE_PRINT2("response_integrity [%s]\n", dump);
>  		}
> +		/* fall through */
>  		case osd_sense_attribute_identification:
>  		{
>  			struct osd_sense_attributes_data_descriptor
> @@ -1879,7 +1880,7 @@ int osd_req_decode_sense_full(struct osd_request *or,
>  					attr_page, attr_id);
>  			}
>  		}
> -		/*These are not legal for OSD*/
> +		/* fall through - These are not legal for OSD */
>  		case scsi_sense_field_replaceable_unit:
>  			OSD_SENSE_PRINT2("scsi_sense_field_replaceable_unit\n");
>  			break;
> 
