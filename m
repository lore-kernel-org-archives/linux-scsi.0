From: Bradley Grove <bgrove@attotech.com>
Subject: Re: [PATCH 1/1] esas2r: Correct typos of "validate" in a comment
Date: Tue, 02 Dec 2014 14:37:07 -0500
Message-ID: <547E14E3.1070303@attotech.com>
References: <54774D8D.2030204@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sw.attotech.com ([208.69.85.34]:50959 "EHLO
	NOTESERV1.attotech.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932903AbaLBThH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Dec 2014 14:37:07 -0500
In-Reply-To: <54774D8D.2030204@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bradley Grove <linuxdrivers@attotech.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, trivial@kernel.org
Cc: Boris Bodemann <bobo.barbarossa@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

Acked-by: Bradley Grove <bgrove@attotech.com>

Thanks,
Brad

On 11/27/2014 11:13 AM, Boris Bodemann wrote:
> From: Boris Bodemann <bobo.barbarossa@gmail.com>
>
> Correct typos of "validate" in a comment
>
> Signed-off-by: Boris Bodemann <bobo.barbarossa@gmail.com>
> ---
> diff -up a/drivers/scsi/esas2r/esas2r_flash.c b/drivers/scsi/esas2r/esas2r_flash.c
> --- a/drivers/scsi/esas2r/esas2r_flash.c        2014-11-21 18:24:10.000000000 +0100
> +++ b/drivers/scsi/esas2r/esas2r_flash.c        2014-11-27 14:49:03.029899303 +0100
> @@ -684,9 +684,9 @@ static u16 calc_fi_checksum(struct esas2
>    *              1)  verify the fi_version is correct
>    *              2)  verify the checksum of the entire image.
>    *              3)  validate the adap_typ, action and length fields.
> - *              4)  valdiate each component header. check the img_type and
> + *              4)  validate each component header. check the img_type and
>    *                  length fields
> - *              5)  valdiate each component image.  validate signatures and
> + *              5)  validate each component image.  validate signatures and
>    *                  local checksums
>    */
>   static bool verify_fi(struct esas2r_adapter *a,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

