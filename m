From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v2 08/12] qla2xxx: Add framework for Async fabric
 discovery.
Date: Tue, 17 Jan 2017 22:14:31 +0000
Message-ID: <1484691258.2729.15.camel@sandisk.com>
References: <1484598924-29066-1-git-send-email-himanshu.madhani@cavium.com>
         <1484598924-29066-9-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1484598924-29066-9-git-send-email-himanshu.madhani@cavium.com>
Content-Language: en-US
Content-ID: <40C7483EC9CABE4482F7D9053E08C0E3@sandisk.com>
Sender: target-devel-owner@vger.kernel.org
To: "bart.vanassche@gmail.com" <bart.vanassche@gmail.com>, "hch@infradead.org" <hch@infradead.org>, "himanshu.madhani@cavium.com" <himanshu.madhani@cavium.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "giridhar.malavali@cavium.com" <giridhar.malavali@cavium.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2017-01-16 at 12:35 -0800, Himanshu Madhani wrote:
> +	     /*
> +	      * return FC_CTELS_STATUS_OK and leave the decoding of the ELS/CT
> +	      * fc payload  to the caller
> +	      */
> +
> +	     bsg_reply->reply_data.ctels_reply.status =3D FC_CTELS_STATUS_OK;
> +	     bsg_job->reply_len =3D sizeof(struct fc_bsg_reply);

smatch reports the following for the above code:

drivers/scsi/qla2xxx/qla_isr.c:1456: qla2x00_ct_entry() warn: inconsistent =
indenting

Please use tabs instead of spaces for indentation. That is sufficient to
suppress that warning.

Thanks,

Bart.=
