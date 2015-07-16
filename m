From: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Subject: Re: [PATCH] ibmvscsi:Remove no longer required comments about return
 values in the file ibmvfc.c
Date: Thu, 16 Jul 2015 14:07:45 -0700
Message-ID: <55A81D21.6030006@linux.vnet.ibm.com>
References: <1436463665-14409-1-git-send-email-xerofoify@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1436463665-14409-1-git-send-email-xerofoify@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nicholas Krause <xerofoify@gmail.com>
Cc: JBottomley@odin.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 07/09/2015 10:41 AM, Nicholas Krause wrote:
> This removes the no longer require comments about the return values
> for the functions ibmvfc_init_host and  ibmvfc_reinit_host due to
> these functions being declared to have a return type of void thus
> making this comments invalid.
> 
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>

Some grammar nit picking. Aside from a couple spelling errors the
wording is a little difficult. Refer to Documentation/SubmittingPatches
section 2. In particular it suggests using the imperative mood.
Something like this would work better:

"Remove comments about return values from ibmvfc_init_host() and
ibmvfc_reinit_host() as they are both declared to have return type void."

Otherwise,

Acked-by: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>

> ---
>  drivers/scsi/ibmvscsi/ibmvfc.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
> index 057d277..c6582db 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc.c
> @@ -528,8 +528,6 @@ static void ibmvfc_set_host_action(struct ibmvfc_host *vhost,
>   * ibmvfc_reinit_host - Re-start host initialization (no NPIV Login)
>   * @vhost:		ibmvfc host struct
>   *
> - * Return value:
> - *	nothing
>   **/
>  static void ibmvfc_reinit_host(struct ibmvfc_host *vhost)
>  {
> @@ -570,8 +568,6 @@ static void ibmvfc_link_down(struct ibmvfc_host *vhost,
>   * ibmvfc_init_host - Start host initialization
>   * @vhost:		ibmvfc host struct
>   *
> - * Return value:
> - *	nothing
>   **/
>  static void ibmvfc_init_host(struct ibmvfc_host *vhost)
>  {
> 
