From: Laurence Oberman <loberman@redhat.com>
Subject: Re: [PATCH] scsi: replace broken specification URL
Date: Thu, 15 Sep 2016 20:57:21 -0400 (EDT)
Message-ID: <1869764937.6268263.1473987441289.JavaMail.zimbra@redhat.com>
References: <7884d730-1d65-73c0-b94d-196bda3211d5@free-electrons.com> <1473944585-18344-1-git-send-email-michael.opdenacker@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1473944585-18344-1-git-send-email-michael.opdenacker@free-electrons.com>
Sender: linux-doc-owner@vger.kernel.org
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: corbet@lwn.net, jejb@linux.vnet.ibm.com, martin petersen <martin.petersen@oracle.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



----- Original Message -----
> From: "Michael Opdenacker" <michael.opdenacker@free-electrons.com>
> To: corbet@lwn.net, jejb@linux.vnet.ibm.com, "martin petersen" <martin.petersen@oracle.com>
> Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, "Michael Opdenacker"
> <michael.opdenacker@free-electrons.com>
> Sent: Thursday, September 15, 2016 9:03:05 AM
> Subject: [PATCH] scsi: replace broken specification URL
> 
> The t10.org website containing SCSI-2 draft specifications now requires
> to be from a member company to access the documents.
> 
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
> ---
>  Documentation/DocBook/scsi.tmpl | 6 +++---
>  drivers/scsi/scsicam.c          | 3 ++-
>  2 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/DocBook/scsi.tmpl
> b/Documentation/DocBook/scsi.tmpl
> index 4b9b9b286cea..b8b646426321 100644
> --- a/Documentation/DocBook/scsi.tmpl
> +++ b/Documentation/DocBook/scsi.tmpl
> @@ -160,9 +160,9 @@
>        <sect2 id="scsicam.c">
>          <title>drivers/scsi/scsicam.c</title>
>          <para>
> -          <ulink
> url='http://www.t10.org/ftp/t10/drafts/cam/cam-r12b.pdf'>SCSI
> -          Common Access Method</ulink> support functions, for use with
> -          HDIO_GETGEO, etc.
> +          <ulink url='http://www.t10.org/t10docs.htm'>SCSI Common Access
> +	  Method</ulink> support functions ('cam-r12b.pdf' document,
> +	  registration required), for use with HDIO_GETGEO, etc.
>          </para>
>  !Edrivers/scsi/scsicam.c
>        </sect2>
> diff --git a/drivers/scsi/scsicam.c b/drivers/scsi/scsicam.c
> index 910f4a7a3924..5c446d9ef468 100644
> --- a/drivers/scsi/scsicam.c
> +++ b/drivers/scsi/scsicam.c
> @@ -207,7 +207,8 @@ EXPORT_SYMBOL(scsi_partsize);
>   *
>   * WORKING                                                    X3T9.2
>   * DRAFT                                                        792D
> - * see http://www.t10.org/ftp/t10/drafts/cam/cam-r12b.pdf
> + * 'cam-r12b.pdf' document on http://www.t10.org/t10docs.htm
> + * (registration required)
>   *
>   *                                                        Revision 6
>   *                                                         10-MAR-94
> --
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
Looks right matching what James wanted as well.
Reviewed-by: Laurence Oberman <loberman@redhat.com>
