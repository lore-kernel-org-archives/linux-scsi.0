From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: Re: [PATCH] isci: fix two comment typos
Date: Mon, 5 Oct 2015 14:31:32 +0200
Message-ID: <56126DA4.6010906@intel.com>
References: <dc5377b7094d5d50cfe037337b301a083869d0c0.1443948690.git.geliangtang@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <dc5377b7094d5d50cfe037337b301a083869d0c0.1443948690.git.geliangtang@163.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Geliang Tang <geliangtang@163.com>, Intel SCU Linux support <intel-linux-scu@intel.com>, "James E.J. Bottomley" <JBottomley@odin.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 10/04/2015 10:53 AM, Geliang Tang wrote:
> Just fix two typos in the code comment.
> 
> Signed-off-by: Geliang Tang <geliangtang@163.com>
> ---
>  drivers/scsi/isci/request.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/isci/request.c b/drivers/scsi/isci/request.c
> index cfd0084..8fe106f 100644
> --- a/drivers/scsi/isci/request.c
> +++ b/drivers/scsi/isci/request.c
> @@ -3306,7 +3306,7 @@ sci_io_request_construct_smp(struct device *dev,
>   * @ireq: This parameter points to the isci_request allocated in the
>   *    request construct function.
>   *
> - * SCI_SUCCESS on successfull completion, or specific failure code.
> + * SCI_SUCCESS on successful completion, or specific failure code.
>   */
>  static enum sci_status isci_smp_request_build(struct isci_request *ireq)
>  {
> @@ -3332,7 +3332,7 @@ static enum sci_status isci_smp_request_build(struct isci_request *ireq)
>   * @sci_device: This parameter is the handle for the sci core's remote device
>   *    object that is the destination for this request.
>   *
> - * SCI_SUCCESS on successfull completion, or specific failure code.
> + * SCI_SUCCESS on successful completion, or specific failure code.
>   */
>  static enum sci_status isci_io_request_build(struct isci_host *ihost,
>  					     struct isci_request *request,
> 

Acked-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>

Thanks,
Artur
