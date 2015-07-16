From: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Subject: Re: [PATCH] ibmvscsi:Remove no longer required comment for the function
 send_mad_adapter_info
Date: Thu, 16 Jul 2015 13:42:08 -0700
Message-ID: <55A81720.5050509@linux.vnet.ibm.com>
References: <1436462664-14263-1-git-send-email-xerofoify@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1436462664-14263-1-git-send-email-xerofoify@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nicholas Krause <xerofoify@gmail.com>
Cc: JBottomley@odin.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 07/09/2015 10:24 AM, Nicholas Krause wrote:
> This removes the no longer required comment for the function
> send_mad_adapter_info stating that it always return zero due
> to this function being declared as void and thus never returning
> any useful value.
> 
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>

Acked-by: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>

> ---
>  drivers/scsi/ibmvscsi/ibmvscsi.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
> index 6a41c36..70ea976 100644
> --- a/drivers/scsi/ibmvscsi/ibmvscsi.c
> +++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
> @@ -1423,7 +1423,6 @@ static void adapter_info_rsp(struct srp_event_struct *evt_struct)
>   *      returned SRP version doesn't match ours.
>   * @hostdata:	ibmvscsi_host_data of host
>   * 
> - * Returns zero if successful.
>  */
>  static void send_mad_adapter_info(struct ibmvscsi_host_data *hostdata)
>  {
> 
